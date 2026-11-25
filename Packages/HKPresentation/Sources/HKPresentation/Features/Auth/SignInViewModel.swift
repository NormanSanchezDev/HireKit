import Observation

@MainActor
@Observable
public final class SignInViewModel {
    public var email = ""
    public var password = ""
    public private(set) var emailError: String?
    public private(set) var passwordError: String?

    private let onSignUp: @MainActor () -> Void
    private let onAuthenticated: @MainActor () -> Void

    public init(
        onSignUp: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void
    ) {
        self.onSignUp = onSignUp
        self.onAuthenticated = onAuthenticated
    }

    public func signIn() {
        emailError = AuthInputValidator.emailError(email)
        passwordError = AuthInputValidator.passwordError(password)
        guard emailError == nil, passwordError == nil else { return }
        onAuthenticated()
    }

    public func goToSignUp() {
        onSignUp()
    }
}
