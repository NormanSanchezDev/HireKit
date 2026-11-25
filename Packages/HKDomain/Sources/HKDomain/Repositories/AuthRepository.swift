/// An account store that signs people in and creates accounts.
///
/// The domain defines the contract and `HKData` implements it on top of the
/// backend, so use cases never know which service answers.
public protocol AuthRepository: Sendable {
    /// Signs in with existing credentials.
    ///
    /// - Parameter credentials: The email and password to check.
    /// - Returns: The signed-in user.
    /// - Throws: An ``AuthenticationError``.
    func signIn(with credentials: AuthCredentials) async throws(AuthenticationError) -> AuthUser

    /// Creates an account.
    ///
    /// - Parameter account: The name, email and password of the new account.
    /// - Returns: Whether the person is signed in or must confirm the email.
    /// - Throws: An ``AuthenticationError``.
    func signUp(_ account: NewAccount) async throws(AuthenticationError) -> SignUpResult
}
