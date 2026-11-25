import Observation
import SwiftUI

/// The state and actions of the sign-in screen.
///
/// The ViewModel validates the form and reports navigation through callbacks,
/// so it never sees a router.
@MainActor
@Observable
public final class SignInViewModel {
    /// The email the user typed.
    public var email = ""

    /// The password the user typed.
    public var password = ""

    /// The validation message for the email, if any.
    public private(set) var emailError: LocalizedStringKey?

    /// The validation message for the password, if any.
    public private(set) var passwordError: LocalizedStringKey?

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

    /// Validates the form and signs in when it is valid.
    public func signIn() {
        emailError = AuthInputValidator.emailError(email)
        passwordError = AuthInputValidator.passwordError(password)
        guard emailError == nil, passwordError == nil else { return }
        onAuthenticated()
    }

    /// Opens the sign-up screen.
    public func goToSignUp() {
        onSignUp()
    }
}
