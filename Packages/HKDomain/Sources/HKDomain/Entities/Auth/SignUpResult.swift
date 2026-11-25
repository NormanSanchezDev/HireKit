/// The outcome of creating an account.
public enum SignUpResult: Sendable, Equatable {
    /// The account exists and the person is signed in.
    case signedIn(AuthUser)

    /// The account exists, but the person must confirm the email address
    /// before signing in.
    case confirmationRequired(email: String)
}
