/// A person with an account in HireKit.
public struct AuthUser: Sendable, Equatable, Identifiable {
    /// The identifier the backend assigned to the account.
    public let id: String

    /// The account's email address.
    public let email: String

    /// The display name stored with the account, if any.
    public let name: String?

    /// Creates a user.
    ///
    /// - Parameters:
    ///   - id: The identifier the backend assigned to the account.
    ///   - email: The account's email address.
    ///   - name: The display name stored with the account, if any.
    public init(id: String, email: String, name: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
    }
}
