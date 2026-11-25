/// The default ``SignUpUseCase``, which normalizes the name and email and asks
/// an ``AuthRepository`` to create the account.
public struct DefaultSignUpUseCase: SignUpUseCase {
    private let repository: any AuthRepository

    /// Creates the use case.
    ///
    /// - Parameter repository: The account store.
    public init(repository: any AuthRepository) {
        self.repository = repository
    }

    /// Creates the account with the name trimmed, the email trimmed and
    /// lowercased, and the password unchanged.
    ///
    /// - Parameter account: The name, email and password the person typed.
    /// - Returns: Whether the person is signed in or must confirm the email.
    /// - Throws: An ``AuthenticationError``.
    public func execute(_ account: NewAccount) async throws(AuthenticationError) -> SignUpResult {
        try await repository.signUp(account.normalized)
    }
}
