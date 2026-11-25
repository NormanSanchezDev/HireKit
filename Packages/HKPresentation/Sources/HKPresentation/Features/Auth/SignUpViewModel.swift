import Observation

/// The state and actions of the sign-up screen.
@MainActor
@Observable
public final class SignUpViewModel {
    /// The name the user typed.
    public var name = ""

    /// The email the user typed.
    public var email = ""

    /// The password the user typed.
    public var password = ""

    /// The validation message for the name, if any.
    public private(set) var nameError: String?

    /// The validation message for the email, if any.
    public private(set) var emailError: String?

    /// The validation message for the password, if any.
    public private(set) var passwordError: String?

    private let onAuthenticated: @MainActor () -> Void

    /// Creates the ViewModel.
    ///
    /// - Parameter onAuthenticated: Called when sign-up succeeds.
    public init(onAuthenticated: @escaping @MainActor () -> Void) {
        self.onAuthenticated = onAuthenticated
    }

    /// Validates the form and creates the account when it is valid.
    public func signUp() {
        nameError = AuthInputValidator.nameError(name)
        emailError = AuthInputValidator.emailError(email)
        passwordError = AuthInputValidator.passwordError(password)
        guard nameError == nil, emailError == nil, passwordError == nil else { return }
        onAuthenticated()
    }
}
