import Foundation

/// The email and password a person signs in with.
public struct AuthCredentials: Sendable, Equatable {
    /// The account's email address.
    public let email: String

    /// The account's password.
    public let password: String

    /// Creates credentials.
    ///
    /// - Parameters:
    ///   - email: The account's email address.
    ///   - password: The account's password.
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }

    /// The credentials with the email trimmed and lowercased. The password
    /// never changes.
    var normalized: AuthCredentials {
        AuthCredentials(
            email: email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
            password: password
        )
    }
}
