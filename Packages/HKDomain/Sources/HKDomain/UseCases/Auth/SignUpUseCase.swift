/// A use case that creates an account.
public protocol SignUpUseCase: Sendable {
    /// Creates an account.
    ///
    /// - Parameter account: The name, email and password the person typed.
    /// - Returns: Whether the person is signed in or must confirm the email.
    /// - Throws: An ``AuthenticationError``.
    func execute(_ account: NewAccount) async throws(AuthenticationError) -> SignUpResult
}
