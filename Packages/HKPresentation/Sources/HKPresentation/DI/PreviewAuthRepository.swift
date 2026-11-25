#if DEBUG
import HKDomain

/// An `AuthRepository` for previews that accepts any credentials.
struct PreviewAuthRepository: AuthRepository {
    func signIn(with credentials: AuthCredentials) async throws(AuthenticationError) -> AuthUser {
        AuthUser(id: "preview", email: credentials.email)
    }

    func signUp(_ account: NewAccount) async throws(AuthenticationError) -> SignUpResult {
        .confirmationRequired(email: account.credentials.email)
    }
}
#endif
