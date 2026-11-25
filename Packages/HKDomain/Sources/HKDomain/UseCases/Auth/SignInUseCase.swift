/// A use case that signs a person in with an email and password.
public protocol SignInUseCase: Sendable {
    /// Signs in with the given credentials.
    ///
    /// - Parameter credentials: The email and password the person typed.
    /// - Returns: The signed-in user.
    /// - Throws: An ``AuthenticationError``.
    func execute(_ credentials: AuthCredentials) async throws(AuthenticationError) -> AuthUser
}
