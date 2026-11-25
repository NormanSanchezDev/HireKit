import Foundation
import HKDomain

/// An `AuthRepository` backed by an ``AuthRemoteDataSource``.
///
/// It maps transport models to domain types. When the backend omits the
/// email, it keeps the one the person typed.
public struct DefaultAuthRepository: AuthRepository {
    private let remoteDataSource: any AuthRemoteDataSource
    private let timeZone: TimeZone

    /// Creates a repository.
    ///
    /// - Parameters:
    ///   - remoteDataSource: The network boundary of authentication.
    ///   - timeZone: The time zone in which a date of birth is a calendar day.
    public init(remoteDataSource: any AuthRemoteDataSource, timeZone: TimeZone = .current) {
        self.remoteDataSource = remoteDataSource
        self.timeZone = timeZone
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
    /// - Parameter account: The profile, email and password of the new account.
    /// - Returns: `.signedIn` when the backend opened a session, otherwise
    ///   `.confirmationRequired`.
    /// - Throws: An `AuthenticationError`.
    public func signUp(_ account: NewAccount) async throws(AuthenticationError) -> SignUpResult {
        let response = try await remoteDataSource.signUp(
            profile: remoteProfile(for: account),
            email: account.credentials.email,
            password: account.credentials.password
        )
        let user = AuthUser(response.user, fallbackEmail: account.credentials.email)
        return response.hasSession ? .signedIn(user) : .confirmationRequired(email: user.email)
    }

    private func remoteProfile(for account: NewAccount) -> RemoteNewProfile {
        RemoteNewProfile(
            firstName: account.firstName,
            paternalLastName: account.paternalLastName,
            maternalLastName: account.maternalLastName,
            birthDate: account.birthDate.formatted(
                Date.ISO8601FormatStyle(timeZone: timeZone).year().month().day()
            ),
            dialCode: account.phone.dialCode.rawValue,
            phone: account.phone.nationalNumber
        )
    }
}

private extension AuthUser {
    init(_ user: RemoteAuthUser, fallbackEmail: String) {
        self.init(id: user.id, email: user.email ?? fallbackEmail, name: user.name)
    }
}
