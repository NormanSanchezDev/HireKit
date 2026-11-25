import HKDesignSystem
import HKDomain
import HKPresentation
import SwiftUI
import Testing

private actor StubAuthUseCases: SignInUseCase, SignUpUseCase {
    private let failure: AuthenticationError?
    private let signUpResult: SignUpResult
    private(set) var receivedCredentials: AuthCredentials?
    private(set) var receivedAccount: NewAccount?

    init(failure: AuthenticationError? = nil, signUpResult: SignUpResult = .signedIn(.sample)) {
        self.failure = failure
        self.signUpResult = signUpResult
    }

    func execute(_ credentials: AuthCredentials) throws(AuthenticationError) -> AuthUser {
        receivedCredentials = credentials
        if let failure { throw failure }
        return .sample
    }

    func execute(_ account: NewAccount) throws(AuthenticationError) -> SignUpResult {
        receivedAccount = account
        if let failure { throw failure }
        return signUpResult
    }
}

private extension AuthUser {
    static let sample = AuthUser(id: "user-1", email: "ana@hirekit.app", name: "Ana")
}

@MainActor
struct SignInViewModelTests {
    @Test func firstAppearancePreparesStateAndLaterAppearancesKeepTypedValues() throws {
        let viewModel = SignInViewModel(signIn: StubAuthUseCases(), onSignUp: {}, onAuthenticated: {})
        #expect(viewModel.uiState == nil)
        viewModel.email = "ignorado@hirekit.app"
        #expect(viewModel.email.isEmpty)

        viewModel.onAppear()
        let state = try #require(viewModel.uiState)
        #expect(state.titleLabel.text == "sign_in_title_txt")
        #expect(state.signInButton.title == "sign_in_submit_button_txt")
        #expect(!state.signInButton.isLoading)

        viewModel.email = "ana@hirekit.app"
        viewModel.onAppear()
        #expect(viewModel.uiState?.email == "ana@hirekit.app")
    }

    @Test func invalidInputShowsErrorsWithoutCallingUseCase() async {
        let useCases = StubAuthUseCases()
        var authenticated = false
        let viewModel = SignInViewModel(signIn: useCases, onSignUp: {}) { authenticated = true }
        viewModel.onAppear()
        viewModel.email = "no-es-correo"
        viewModel.password = "123"
        await viewModel.signIn()
        #expect(!authenticated)
        #expect(viewModel.uiState?.emailField.errorMessage != nil)
        #expect(viewModel.uiState?.passwordField.errorMessage != nil)
        #expect(await useCases.receivedCredentials == nil)
    }

    @Test func validInputSignsInThroughUseCase() async {
        let useCases = StubAuthUseCases()
        var authenticated = false
        let viewModel = SignInViewModel(signIn: useCases, onSignUp: {}) { authenticated = true }
        viewModel.onAppear()
        viewModel.email = "ana@hirekit.app"
        viewModel.password = "contraseña"
        await viewModel.signIn()
        #expect(authenticated)
        #expect(await useCases.receivedCredentials == AuthCredentials(email: "ana@hirekit.app", password: "contraseña"))
        #expect(viewModel.uiState?.isLoading == false)
        #expect(!viewModel.isShowingError)
    }

    @Test func failureShowsMappedErrorAndStays() async {
        var authenticated = false
        let viewModel = SignInViewModel(
            signIn: StubAuthUseCases(failure: .invalidCredentials),
            onSignUp: {}
        ) { authenticated = true }
        viewModel.onAppear()
        viewModel.email = "ana@hirekit.app"
        viewModel.password = "contraseña"
        await viewModel.signIn()
        #expect(!authenticated)
        #expect(viewModel.uiState?.errorMessage == "auth_error_invalid_credentials_txt")
        #expect(viewModel.isShowingError)
        viewModel.isShowingError = false
        #expect(viewModel.uiState?.errorMessage == nil)
    }

    @Test func signInBeforeAppearanceDoesNothing() async {
        let useCases = StubAuthUseCases()
        let viewModel = SignInViewModel(signIn: useCases, onSignUp: {}, onAuthenticated: {})
        await viewModel.signIn()
        #expect(viewModel.uiState == nil)
        #expect(await useCases.receivedCredentials == nil)
    }

    @Test func createAccountRequestsSignUp() {
        var requested = false
        let viewModel = SignInViewModel(signIn: StubAuthUseCases(), onSignUp: { requested = true }, onAuthenticated: {})
        viewModel.goToSignUp()
        #expect(requested)
    }
}

@MainActor
struct SignUpViewModelTests {
    private func makeViewModel(
        useCases: StubAuthUseCases,
        onAuthenticated: @escaping @MainActor () -> Void = {},
        onConfirmationRequired: @escaping @MainActor () -> Void = {}
    ) -> SignUpViewModel {
        let viewModel = SignUpViewModel(
            signUp: useCases,
            onAuthenticated: onAuthenticated,
            onConfirmationRequired: onConfirmationRequired
        )
        viewModel.onAppear()
        viewModel.email = "ana@hirekit.app"
        viewModel.password = "contraseña"
        return viewModel
    }

    @Test func firstAppearancePreparesState() throws {
        let viewModel = SignUpViewModel(signUp: StubAuthUseCases(), onAuthenticated: {}, onConfirmationRequired: {})
        #expect(viewModel.uiState == nil)
        viewModel.onAppear()
        let state = try #require(viewModel.uiState)
        #expect(state.titleLabel.text == "sign_up_title_txt")
        #expect(state.signUpButton.title == "sign_up_submit_button_txt")
        #expect(state.confirmationMessage == nil)
    }

    @Test func missingNameShowsErrorWithoutCallingUseCase() async {
        let useCases = StubAuthUseCases()
        var authenticated = false
        let viewModel = makeViewModel(useCases: useCases) { authenticated = true }
        await viewModel.signUp()
        #expect(!authenticated)
        #expect(viewModel.uiState?.nameField.errorMessage != nil)
        #expect(await useCases.receivedAccount == nil)
    }

    @Test func sessionAuthenticates() async {
        let useCases = StubAuthUseCases()
        var authenticated = false
        let viewModel = makeViewModel(useCases: useCases) { authenticated = true }
        viewModel.name = "Ana"
        await viewModel.signUp()
        #expect(authenticated)
        #expect(await useCases.receivedAccount?.name == "Ana")
    }

    @Test func confirmationRequiredShowsAlertThenReturnsToSignIn() async {
        var authenticated = false
        var returned = false
        let viewModel = makeViewModel(
            useCases: StubAuthUseCases(signUpResult: .confirmationRequired(email: "ana@hirekit.app")),
            onAuthenticated: { authenticated = true },
            onConfirmationRequired: { returned = true }
        )
        viewModel.name = "Ana"
        await viewModel.signUp()
        #expect(!authenticated)
        #expect(viewModel.isShowingConfirmation)
        #expect(viewModel.uiState?.pendingConfirmationEmail == "ana@hirekit.app")
        viewModel.acknowledgeConfirmation()
        #expect(returned)
        #expect(!viewModel.isShowingConfirmation)
    }

    @Test func failureShowsMappedError() async {
        let viewModel = makeViewModel(useCases: StubAuthUseCases(failure: .emailAlreadyRegistered))
        viewModel.name = "Ana"
        await viewModel.signUp()
        #expect(viewModel.uiState?.errorMessage == "auth_error_email_already_registered_txt")
        #expect(viewModel.uiState?.isLoading == false)
    }
}
