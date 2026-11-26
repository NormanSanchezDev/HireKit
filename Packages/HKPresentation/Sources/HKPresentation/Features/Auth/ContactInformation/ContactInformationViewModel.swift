import Foundation
import HKDomain
import Observation

/// The state and actions of the contact information step of sign-up.
///
/// The ViewModel seeds ``ContactInformationUIState`` from the shared
/// ``SignUpDraft``, writes the email and phone back to it, validates the
/// step and creates the account with the personal information of the first
/// step. The password stays only in the screen state and is sent only to the
/// sign-up use case.
@MainActor
@Observable
public final class ContactInformationViewModel {
    /// The screen state, created by ``onAppear()``.
    public private(set) var uiState: ContactInformationUIState?

    /// The email the person typed. Edits before ``onAppear()`` are ignored.
    public var email: String {
        get { uiState?.email ?? "" }
        set {
            guard uiState != nil else { return }
            uiState?.email = newValue
            draft.email = newValue
            if uiState?.emailError != nil {
                uiState?.emailError = ContactInformationValidator.emailError(newValue)
            }
        }
    }

    /// The calling code of the phone number. Edits before ``onAppear()`` are
    /// ignored.
    public var dialCode: DialCode {
        get { uiState?.dialCode ?? draft.dialCode }
        set {
            guard uiState != nil else { return }
            uiState?.dialCode = newValue
            draft.dialCode = newValue
        }
    }

    /// The national phone number, digits only. Edits before ``onAppear()``
    /// are ignored.
    public var phoneDigits: String {
        get { uiState?.phoneDigits ?? "" }
        set {
            guard uiState != nil else { return }
            uiState?.phoneDigits = newValue
            draft.phoneDigits = newValue
            if uiState?.phoneError != nil {
                uiState?.phoneError = ContactInformationValidator.phoneError(newValue)
            }
        }
    }

    /// The password the person typed. Edits before ``onAppear()`` are ignored.
    public var password: String {
        get { uiState?.password ?? "" }
        set {
            guard uiState != nil else { return }
            uiState?.password = newValue
            if uiState?.passwordError != nil {
                uiState?.passwordError = ContactInformationValidator.passwordError(newValue)
            }
        }
    }

    /// Whether the error alert is on screen. Setting it to `false` closes it.
    public var isShowingError: Bool {
        get { uiState?.errorMessage != nil }
        set { if !newValue { dismissError() } }
    }

    /// Whether the confirmation alert is on screen. Setting it to `false`
    /// closes it.
    public var isShowingConfirmation: Bool {
        get { uiState?.pendingConfirmationEmail != nil }
        set { if !newValue { uiState?.pendingConfirmationEmail = nil } }
    }

    private let draft: SignUpDraft
    private let signUpUseCase: any SignUpUseCase
    private let onBack: @MainActor () -> Void
    private let onAuthenticated: @MainActor () -> Void
    private let onConfirmationRequired: @MainActor () -> Void

    /// Creates the ViewModel.
    ///
    /// - Parameters:
    ///   - draft: The values shared by the sign-up steps.
    ///   - signUp: The use case that creates the account.
    ///   - onBack: Called when the person returns to the personal
    ///     information step.
    ///   - onAuthenticated: Called when the account is created with a session.
    ///   - onConfirmationRequired: Called after the person acknowledges that
    ///     the email must be confirmed before signing in.
    public init(
        draft: SignUpDraft,
        signUp: any SignUpUseCase,
        onBack: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void,
        onConfirmationRequired: @escaping @MainActor () -> Void
    ) {
        self.draft = draft
        signUpUseCase = signUp
        self.onBack = onBack
        self.onAuthenticated = onAuthenticated
        self.onConfirmationRequired = onConfirmationRequired
    }

    /// Prepares the screen from the draft on first appearance, preserving
    /// typed values and in-flight work on later appearances.
    public func onAppear() {
        guard uiState == nil else { return }
        uiState = ContactInformationUIState(
            email: draft.email,
            dialCode: draft.dialCode,
            phoneDigits: draft.phoneDigits,
            onCreateAccount: { [weak self] in
                Task { await self?.createAccount() }
            },
            onBack: { [weak self] in self?.goBack() },
            onRetry: { [weak self] in
                Task { await self?.retry() }
            },
            onConfirmationAcknowledged: { [weak self] in self?.acknowledgeConfirmation() }
        )
    }

    /// Validates the step and, when it is valid, creates the account.
    ///
    /// It does nothing before ``onAppear()`` or while a request is in
    /// flight, so repeated taps send one request.
    public func createAccount() async {
        guard let current = uiState, !current.isLoading else { return }
        guard let account = validatedAccount() else { return }

        uiState?.errorMessage = nil
        uiState?.canRetry = false
        uiState?.isLoading = true
        defer { uiState?.isLoading = false }
        do throws(AuthenticationError) {
            switch try await signUpUseCase.execute(account) {
            case .signedIn:
                uiState?.password = ""
                onAuthenticated()
            case let .confirmationRequired(email):
                uiState?.password = ""
                uiState?.pendingConfirmationEmail = email
            }
        } catch {
            uiState?.canRetry = error == .network
            uiState?.errorMessage = error.message
        }
    }

    /// Closes the error alert and sends the request again.
    public func retry() async {
        dismissError()
        await createAccount()
    }

    /// Returns to the personal information step. The draft keeps the email
    /// and phone, never the password.
    public func goBack() {
        guard let state = uiState, !state.isLoading else { return }
        onBack()
    }

    /// Closes the confirmation alert and returns to sign in.
    public func acknowledgeConfirmation() {
        uiState?.pendingConfirmationEmail = nil
        onConfirmationRequired()
    }

    private func dismissError() {
        uiState?.errorMessage = nil
        uiState?.canRetry = false
    }

    private func validatedAccount() -> NewAccount? {
        guard var state = uiState else { return nil }
        state.emailError = ContactInformationValidator.emailError(state.email)
        state.phoneError = ContactInformationValidator.phoneError(state.phoneDigits)
        state.passwordError = ContactInformationValidator.passwordError(state.password)
        uiState = state

        guard state.emailError == nil, state.phoneError == nil, state.passwordError == nil,
              let phone = PhoneNumber(dialCode: state.dialCode, digits: state.phoneDigits)
        else { return nil }
        let contact = ContactInformation(email: state.email, phone: phone, password: state.password)
        return NewAccount(personal: draft.personal, contact: contact)
    }
}
