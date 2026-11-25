/// The backend's answer to an account creation request.
public struct RemoteSignUpResponse: Sendable, Equatable {
    /// The account that was created.
    public let user: RemoteAuthUser

    /// Whether the backend also opened a session. It is `false` when the
    /// project requires email confirmation.
    public let hasSession: Bool

    /// Creates a response.
    ///
    /// - Parameters:
    ///   - user: The account that was created.
    ///   - hasSession: Whether the backend also opened a session.
    public init(user: RemoteAuthUser, hasSession: Bool) {
        self.user = user
        self.hasSession = hasSession
    }
}
