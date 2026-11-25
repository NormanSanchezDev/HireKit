import HKDomain

/// The network boundary of authentication.
///
/// It returns transport models and throws domain errors already mapped from
/// the backend, so ``DefaultAuthRepository`` stays independent of any SDK.
public protocol AuthRemoteDataSource: Sendable {
    /// Signs in with an email and password.
    ///
    /// - Parameters:
    ///   - email: The account's email address.
    ///   - password: The account's password.
    /// - Returns: The signed-in user.
    /// - Throws: An `AuthenticationError`.
    func signIn(email: String, password: String) async throws(AuthenticationError) -> RemoteAuthUser

    /// Creates an account.
    ///
    /// - Parameters:
    ///   - name: The display name stored in the account's metadata.
    ///   - email: The account's email address.
    ///   - password: The account's password.
    /// - Returns: The created account and whether a session was opened.
    /// - Throws: An `AuthenticationError`.
    func signUp(name: String, email: String, password: String) async throws(AuthenticationError) -> RemoteSignUpResponse
}
