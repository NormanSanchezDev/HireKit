import HKDesignSystem
import HKDomain
import HKPresentation
import SwiftUI
import Testing

@MainActor
struct ContactInformationViewModelTests {
    private func makeDraft() -> SignUpDraft {
        let draft = SignUpDraft()
        draft.personal = SignUpFixtures.personal
        return draft
    }

    private func makeViewModel(
        useCases: StubAuthUseCases,
        draft: SignUpDraft? = nil,
        filled: Bool = true,
        onBack: @escaping @MainActor () -> Void = {},
        onAuthenticated: @escaping @MainActor () -> Void = {},
        onConfirmationRequired: @escaping @MainActor () -> Void = {}
    ) -> ContactInformationViewModel {
        let viewModel = ContactInformationViewModel(
            draft: draft ?? makeDraft(),
            signUp: useCases,
            onBack: onBack,
            onAuthenticated: onAuthenticated,
            onConfirmationRequired: onConfirmationRequired
        )
        viewModel.onAppear()
        if filled {
            viewModel.email = "ana@hirekit.app"
            viewModel.phoneDigits = SignUpFixtures.phoneDigits
            viewModel.password = "contraseña"
        }
        return viewModel
    }

    @Test func firstAppearancePreparesTheStep() throws {
        let viewModel = makeViewModel(useCases: StubAuthUseCases(), filled: false)
        let state = try #require(viewModel.uiState)
        #expect(state.titleLabel.text == "contact_information_title_txt")
        #expect(state.progress.progress == 1)
        #expect(state.progress.label != nil)
        #expect(state.passwordField.isSecure)
        #expect(state.dialCode == .mexico)
        #expect(state.phoneField.dialCodes.map(\.title) == ["🇲🇽 +52", "🇺🇸 +1"])
        #expect(state.createAccountButton.title == "contact_information_create_account_button_txt")
        #expect(state.confirmationMessage == nil)
    }

    @Test func emptyStepShowsErrorsWithoutCallingUseCase() async throws {
        let useCases = StubAuthUseCases()
        let viewModel = makeViewModel(useCases: useCases, filled: false)
        await viewModel.createAccount()
        let state = try #require(viewModel.uiState)
        #expect(state.emailError == "auth_email_required_txt")
        #expect(state.phoneError == "sign_up_phone_required_txt")
        #expect(state.passwordError == "auth_password_required_txt")
        #expect(await useCases.signUpCallCount == 0)

        viewModel.email = "ana@hirekit.app"
        #expect(viewModel.uiState?.emailError == nil)
    }

    @Test func sessionAuthenticatesWithBothSteps() async throws {
        let useCases = StubAuthUseCases()
        var authenticated = false
        let viewModel = makeViewModel(useCases: useCases, onAuthenticated: { authenticated = true })
        viewModel.dialCode = .unitedStates
        await viewModel.createAccount()
        #expect(authenticated)
        let account = try #require(await useCases.receivedAccount)
        #expect(account.firstName == "Ana")
        #expect(account.paternalLastName == "López")
        #expect(account.maternalLastName == nil)
        #expect(account.birthDate == SignUpFixtures.adultBirthDate)
        #expect(account.phone == PhoneNumber(dialCode: .unitedStates, digits: SignUpFixtures.phoneDigits))
        #expect(account.credentials == AuthCredentials(email: "ana@hirekit.app", password: "contraseña"))
        #expect(viewModel.password.isEmpty)
    }

    @Test func repeatedTapsSendOneRequest() async {
        let useCases = StubAuthUseCases()
        let viewModel = makeViewModel(useCases: useCases)
        async let first: Void = viewModel.createAccount()
        async let second: Void = viewModel.createAccount()
        _ = await (first, second)
        #expect(await useCases.signUpCallCount == 1)
    }

    @Test func confirmationRequiredShowsAlertThenReturnsToSignIn() async {
        var authenticated = false
        var returned = false
        let viewModel = makeViewModel(
            useCases: StubAuthUseCases(signUpResult: .confirmationRequired(email: "ana@hirekit.app")),
            onAuthenticated: { authenticated = true },
            onConfirmationRequired: { returned = true }
        )
        await viewModel.createAccount()
        #expect(!authenticated)
        #expect(viewModel.isShowingConfirmation)
        #expect(viewModel.uiState?.pendingConfirmationEmail == "ana@hirekit.app")
        viewModel.acknowledgeConfirmation()
        #expect(returned)
        #expect(!viewModel.isShowingConfirmation)
    }

    @Test func registeredEmailShowsSafeMessageWithoutRetry() async {
        let viewModel = makeViewModel(useCases: StubAuthUseCases(failure: .emailAlreadyRegistered))
        await viewModel.createAccount()
        #expect(viewModel.uiState?.errorMessage == "auth_error_email_already_registered_txt")
        #expect(viewModel.uiState?.canRetry == false)
        #expect(viewModel.uiState?.isLoading == false)
        viewModel.isShowingError = false
        #expect(viewModel.uiState?.errorMessage == nil)
    }

    @Test func networkErrorOffersRetry() async {
        let useCases = StubAuthUseCases(failure: .network)
        let viewModel = makeViewModel(useCases: useCases)
        await viewModel.createAccount()
        #expect(viewModel.uiState?.errorMessage == "auth_error_network_txt")
        #expect(viewModel.uiState?.canRetry == true)
        await viewModel.retry()
        #expect(await useCases.signUpCallCount == 2)
    }

    @Test func draftKeepsEmailAndPhoneButNeverThePassword() {
        let draft = makeDraft()
        var backs = 0
        let first = makeViewModel(useCases: StubAuthUseCases(), draft: draft, onBack: { backs += 1 })
        first.goBack()
        #expect(backs == 1)
        #expect(draft.email == "ana@hirekit.app")
        #expect(draft.phoneDigits == SignUpFixtures.phoneDigits)

        let second = makeViewModel(useCases: StubAuthUseCases(), draft: draft, filled: false)
        #expect(second.email == "ana@hirekit.app")
        #expect(second.phoneDigits == SignUpFixtures.phoneDigits)
        #expect(second.password.isEmpty)
    }
}
