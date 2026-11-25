import Observation

@MainActor
@Observable
public final class SignUpViewModel {
    public var name = ""
    public var email = ""
    public var password = ""
    public private(set) var nameError: String?
    public private(set) var emailError: String?
    public private(set) var passwordError: String?

    private let onAuthenticated: @MainActor () -> Void

    public init(onAuthenticated: @escaping @MainActor () -> Void) {
        self.onAuthenticated = onAuthenticated
    }

    public func signUp() {
        nameError = AuthInputValidator.nameError(name)
        emailError = AuthInputValidator.emailError(email)
        passwordError = AuthInputValidator.passwordError(password)
        guard nameError == nil, emailError == nil, passwordError == nil else { return }
        onAuthenticated()
    }
}
