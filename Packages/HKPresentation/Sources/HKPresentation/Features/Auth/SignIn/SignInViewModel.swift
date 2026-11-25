import Observation
import SwiftUI

/// The state and actions of the sign-in screen.
///
/// The ViewModel validates the form and reports navigation through callbacks,
/// so it never sees a router.
@MainActor
@Observable
public final class SignInViewModel {
    /// The screen state, prepared on first appearance.
    public private(set) var uiState: SignInUIState?

    /// The email the user typed.
    public var email: String { get { uiState?.email ?? "" } set { uiState?.email = newValue } }

    /// The password the user typed.
    public var password: String { get { uiState?.password ?? "" } set { uiState?.password = newValue } }

    /// The validation message for the email, if any.
    public var emailError: LocalizedStringKey? { uiState?.emailError }

    /// The validation message for the password, if any.
    public var passwordError: LocalizedStringKey? { uiState?.passwordError }

    private let onSignUp: @MainActor () -> Void
    private let onAuthenticated: @MainActor () -> Void

    /// Creates the ViewModel.
    ///
    /// - Parameters:
    ///   - onSignUp: Called when the user wants to create an account.
    ///   - onAuthenticated: Called when sign-in succeeds.
    public init(
        onSignUp: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void
    ) {
        self.onSignUp = onSignUp
        self.onAuthenticated = onAuthenticated
    }

    /// Prepares the sign-in screen once when it appears.
    public func onAppear() {
        guard uiState == nil else { return }
        uiState = SignInUIState(onSignIn: { [weak self] in self?.signIn() }, onCreateAccount: { [weak self] in self?.goToSignUp() })
    }

    /// Validates the form and signs in when it is valid.
    public func signIn() {
        onAppear()
        uiState?.emailError = AuthInputValidator.emailError(email)
        uiState?.passwordError = AuthInputValidator.passwordError(password)
        guard emailError == nil, passwordError == nil else { return }
        onAuthenticated()
    }

    /// Opens the sign-up screen.
    public func goToSignUp() {
        onSignUp()
    }
}
