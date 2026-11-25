/// A reason why signing in or creating an account failed.
///
/// `HKData` maps backend errors to these cases, so the presentation layer can
/// show a message without knowing which backend answered.
public enum AuthenticationError: Error, Sendable, Equatable, CaseIterable {
    /// The email and password do not match an account.
    case invalidCredentials

    /// The account exists, but its email address is not confirmed yet.
    case emailNotConfirmed

    /// An account with that email address already exists.
    case emailAlreadyRegistered

    /// The backend rejected the password as too weak.
    case weakPassword

    /// Too many attempts in a short time.
    case rateLimited

    /// The device could not reach the backend.
    case network

    /// The app has no backend configuration.
    case notConfigured

    /// Any other failure.
    case unknown
}
