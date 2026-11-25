/// The default ``SignInUseCase``, which normalizes the email and asks an
/// ``AuthRepository`` to sign in.
public struct DefaultSignInUseCase: SignInUseCase {
    private let repository: any AuthRepository

    /// Creates the use case.
    ///
    /// - Parameter repository: The account store.
    public init(repository: any AuthRepository) {
        self.repository = repository
    }

    /// Signs in with the email trimmed and lowercased, and the password unchanged.
    ///
    /// - Parameter credentials: The email and password the person typed.
    /// - Returns: The signed-in user.
    /// - Throws: An ``AuthenticationError``.
    public func execute(_ credentials: AuthCredentials) async throws(AuthenticationError) -> AuthUser {
        try await repository.signIn(with: credentials.normalized)
    }
}
