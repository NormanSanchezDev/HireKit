import Foundation
import HKDomain
import Supabase

/// An ``AuthRemoteDataSource`` backed by Supabase Auth.
///
/// Supabase keeps the session in the Keychain and refreshes it on its own.
/// Without a ``SupabaseConfiguration`` every request fails with
/// `AuthenticationError.notConfigured`, so the app still launches.
public struct SupabaseAuthRemoteDataSource: AuthRemoteDataSource {
    static let nameMetadataKey = "name"

    private let client: SupabaseClient?

    /// Creates a data source.
    ///
    /// - Parameter configuration: The project to connect to, or `nil` when
    ///   the app has no configuration.
    public init(configuration: SupabaseConfiguration?) {
        client = configuration.map {
            SupabaseClient(
                supabaseURL: $0.url,
                supabaseKey: $0.publishableKey,
                options: SupabaseClientOptions(auth: .init(emitLocalSessionAsInitialSession: true))
            )
        }
    }

    /// Signs in with an email and password.
    ///
    /// - Parameters:
    ///   - email: The account's email address.
    ///   - password: The account's password.
    /// - Returns: The signed-in user.
    /// - Throws: An `AuthenticationError`.
    public func signIn(email: String, password: String) async throws(AuthenticationError) -> RemoteAuthUser {
        let auth = try configuredAuth()
        do {
            let session = try await auth.signIn(email: email, password: password)
            return RemoteAuthUser(session.user)
        } catch {
            throw SupabaseAuthErrorMapper.map(error)
        }
    }

    /// Creates an account and stores the name in its metadata.
    ///
    /// - Parameters:
    ///   - name: The display name stored in the account's metadata.
    ///   - email: The account's email address.
    ///   - password: The account's password.
    /// - Returns: The created account and whether a session was opened.
    /// - Throws: An `AuthenticationError`.
    public func signUp(
        name: String,
        email: String,
        password: String
    ) async throws(AuthenticationError) -> RemoteSignUpResponse {
        let auth = try configuredAuth()
        do {
            let response = try await auth.signUp(
                email: email,
                password: password,
                data: [Self.nameMetadataKey: .string(name)]
            )
            return RemoteSignUpResponse(user: RemoteAuthUser(response.user), hasSession: response.session != nil)
        } catch {
            throw SupabaseAuthErrorMapper.map(error)
        }
    }

    private func configuredAuth() throws(AuthenticationError) -> AuthClient {
        guard let client else { throw .notConfigured }
        return client.auth
    }
}

private extension RemoteAuthUser {
    init(_ user: User) {
        self.init(
            id: user.id.uuidString,
            email: user.email,
            name: user.userMetadata[SupabaseAuthRemoteDataSource.nameMetadataKey]?.stringValue
        )
    }
}
