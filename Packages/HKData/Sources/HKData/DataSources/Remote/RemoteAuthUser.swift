/// A user as the auth backend returns it, before mapping to the domain.
public struct RemoteAuthUser: Sendable, Equatable {
    /// The identifier the backend assigned to the account.
    public let id: String

    /// The account's email address, when the backend returns one.
    public let email: String?

    /// The display name built from the account's metadata, if any.
    public let name: String?

    /// Creates a remote user.
    ///
    /// - Parameters:
    ///   - id: The identifier the backend assigned to the account.
    ///   - email: The account's email address, when the backend returns one.
    ///   - name: The display name stored in the account's metadata, if any.
    public init(id: String, email: String?, name: String?) {
        self.id = id
        self.email = email
        self.name = name
    }
}
