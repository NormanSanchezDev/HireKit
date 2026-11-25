import Foundation

/// The data a person provides to create an account.
public struct NewAccount: Sendable, Equatable {
    /// The person's display name.
    public let name: String

    /// The email and password of the new account.
    public let credentials: AuthCredentials

    /// Creates the data of a new account.
    ///
    /// - Parameters:
    ///   - name: The person's display name.
    ///   - credentials: The email and password of the new account.
    public init(name: String, credentials: AuthCredentials) {
        self.name = name
        self.credentials = credentials
    }

    /// The account with the name trimmed and the credentials normalized.
    var normalized: NewAccount {
        NewAccount(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            credentials: credentials.normalized
        )
    }
}
