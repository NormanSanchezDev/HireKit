import HKDesignSystem
import HKDomain
import HKPresentation
import SwiftUI
import Testing

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
