import HKDomain

/// An `AuthRepository` backed by an ``AuthRemoteDataSource``.
///
/// It maps transport models to domain types. When the backend omits the
/// email, it keeps the one the person typed.
public struct DefaultAuthRepository: AuthRepository {
    private let remoteDataSource: any AuthRemoteDataSource

    /// Creates a repository.
    ///
    /// - Parameter remoteDataSource: The network boundary of authentication.
    public init(remoteDataSource: any AuthRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    /// Signs in with existing credentials.
    ///
    /// - Parameter credentials: The email and password to check.
    /// - Returns: The signed-in user.
    /// - Throws: An `AuthenticationError`.
    public func signIn(with credentials: AuthCredentials) async throws(AuthenticationError) -> AuthUser {
        let user = try await remoteDataSource.signIn(email: credentials.email, password: credentials.password)
        return AuthUser(user, fallbackEmail: credentials.email)
    }

    /// Creates an account.
    ///
    /// - Parameter account: The name, email and password of the new account.
    /// - Returns: `.signedIn` when the backend opened a session, otherwise
    ///   `.confirmationRequired`.
    /// - Throws: An `AuthenticationError`.
    public func signUp(_ account: NewAccount) async throws(AuthenticationError) -> SignUpResult {
        let response = try await remoteDataSource.signUp(
            name: account.name,
            email: account.credentials.email,
            password: account.credentials.password
        )
        let user = AuthUser(response.user, fallbackEmail: account.credentials.email)
        return response.hasSession ? .signedIn(user) : .confirmationRequired(email: user.email)
    }
}

private extension AuthUser {
    init(_ user: RemoteAuthUser, fallbackEmail: String) {
        self.init(id: user.id, email: user.email ?? fallbackEmail, name: user.name)
    }
}
