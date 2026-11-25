import HKDomain
import Observation
import SwiftUI

/// The state and actions of the sign-up screen.
///
/// The ViewModel prepares ``SignUpUIState`` on first appearance, validates the
/// form, creates the account through ``SignUpUseCase`` and reports navigation
/// through callbacks.
@MainActor
@Observable
public final class SignUpViewModel {
    /// The screen state, created by ``onAppear()``.
    public private(set) var uiState: SignUpUIState?

    /// The name the user typed. Edits before ``onAppear()`` are ignored.
    public var name: String {
        get { uiState?.name ?? "" }
        set { uiState?.name = newValue }
    }

    /// The email the user typed. Edits before ``onAppear()`` are ignored.
    public var email: String {
        get { uiState?.email ?? "" }
        set { uiState?.email = newValue }
    }

    /// The password the user typed. Edits before ``onAppear()`` are ignored.
    public var password: String {
        get { uiState?.password ?? "" }
        set { uiState?.password = newValue }
    }

    /// A Boolean value that indicates whether the error alert is showing.
    /// Setting it to `false` clears the error.
    public var isShowingError: Bool {
        get { uiState?.errorMessage != nil }
        set { if !newValue { uiState?.errorMessage = nil } }
    }

    /// A Boolean value that indicates whether the confirmation alert is
    /// showing. Setting it to `false` clears the pending address.
    public var isShowingConfirmation: Bool {
        get { uiState?.pendingConfirmationEmail != nil }
        set { if !newValue { uiState?.pendingConfirmationEmail = nil } }
    }

    private let signUpUseCase: any SignUpUseCase
    private let onAuthenticated: @MainActor () -> Void
    private let onConfirmationRequired: @MainActor () -> Void

    /// Creates the ViewModel.
    ///
    /// - Parameters:
    ///   - signUp: The use case that creates the account.
    ///   - onAuthenticated: Called when the account is created with a session.
    ///   - onConfirmationRequired: Called after the user acknowledges that the
    ///     email must be confirmed before signing in.
    public init(
        signUp: any SignUpUseCase,
        onAuthenticated: @escaping @MainActor () -> Void,
        onConfirmationRequired: @escaping @MainActor () -> Void
    ) {
        signUpUseCase = signUp
        self.onAuthenticated = onAuthenticated
        self.onConfirmationRequired = onConfirmationRequired
    }

    /// Prepares the screen once, preserving typed values and in-flight work
    /// on later appearances.
    public func onAppear() {
        guard uiState == nil else { return }
        uiState = SignUpUIState(
            onSignUp: { [weak self] in
                Task { await self?.signUp() }
            },
            onConfirmationAcknowledged: { [weak self] in
                self?.acknowledgeConfirmation()
            }
        )
    }

    /// Validates the form and, when it is valid, creates the account.
    ///
    /// It does nothing before ``onAppear()`` or while a request is in flight.
    public func signUp() async {
        guard let state = uiState, !state.isLoading else { return }
        let nameError = AuthInputValidator.nameError(state.name)
        let emailError = AuthInputValidator.emailError(state.email)
        let passwordError = AuthInputValidator.passwordError(state.password)
        uiState?.nameError = nameError
        uiState?.emailError = emailError
        uiState?.passwordError = passwordError
        guard nameError == nil, emailError == nil, passwordError == nil else { return }

        uiState?.errorMessage = nil
        uiState?.isLoading = true
        defer { uiState?.isLoading = false }
        let account = NewAccount(
            name: state.name,
            credentials: AuthCredentials(email: state.email, password: state.password)
        )
        do throws(AuthenticationError) {
            switch try await signUpUseCase.execute(account) {
            case .signedIn:
                onAuthenticated()
            case let .confirmationRequired(email):
                uiState?.pendingConfirmationEmail = email
            }
        } catch {
            uiState?.errorMessage = error.message
        }
    }

    /// Closes the confirmation alert and returns to sign in.
    public func acknowledgeConfirmation() {
        uiState?.pendingConfirmationEmail = nil
        onConfirmationRequired()
    }
}
