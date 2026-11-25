import Foundation
import HKData
import HKDomain
import Testing

struct DefaultAuthRepositoryTests {
    private final class ProfileRecorder: @unchecked Sendable {
        var profile: RemoteNewProfile?
    }

    private struct StubAuthRemoteDataSource: AuthRemoteDataSource {
        var recorder = ProfileRecorder()
        var user = RemoteAuthUser(id: "user-1", email: "ana@hirekit.app", name: "Ana")
        var hasSession = true
        var failure: AuthenticationError?

        func signIn(email: String, password: String) throws(AuthenticationError) -> RemoteAuthUser {
            if let failure { throw failure }
            return user
        }

        func signUp(profile: RemoteNewProfile, email: String, password: String) throws(AuthenticationError) -> RemoteSignUpResponse {
            recorder.profile = profile
            if let failure { throw failure }
            return RemoteSignUpResponse(user: user, hasSession: hasSession)
        }
    }

    private let credentials = AuthCredentials(email: "ana@hirekit.app", password: "secreta123")
    private let utc = TimeZone(identifier: "UTC")!

    private var account: NewAccount {
        NewAccount(
            firstName: "Ana",
            paternalLastName: "López",
            maternalLastName: nil,
            birthDate: Date(timeIntervalSince1970: 631_152_000),
            phone: PhoneNumber(dialCode: .mexico, digits: "5625068370")!,
            credentials: credentials
        )
    }

    @Test func signUpSendsProfileAsPlainStrings() async throws {
        let remote = StubAuthRemoteDataSource()
        _ = try await DefaultAuthRepository(remoteDataSource: remote, timeZone: utc).signUp(account)
        #expect(remote.recorder.profile == RemoteNewProfile(
            firstName: "Ana",
            paternalLastName: "López",
            maternalLastName: nil,
            birthDate: "1990-01-01",
            dialCode: "+52",
            phone: "5625068370"
        ))
    }

    @Test func signInMapsRemoteUser() async throws {
        let repository = DefaultAuthRepository(remoteDataSource: StubAuthRemoteDataSource())
        let user = try await repository.signIn(with: credentials)
        #expect(user == AuthUser(id: "user-1", email: "ana@hirekit.app", name: "Ana"))
    }

    @Test func signInKeepsTypedEmailWhenBackendOmitsIt() async throws {
        let remote = StubAuthRemoteDataSource(user: RemoteAuthUser(id: "user-1", email: nil, name: nil))
        let user = try await DefaultAuthRepository(remoteDataSource: remote).signIn(with: credentials)
        #expect(user.email == "ana@hirekit.app")
    }

    @Test func signInPropagatesErrors() async {
        let repository = DefaultAuthRepository(remoteDataSource: StubAuthRemoteDataSource(failure: .invalidCredentials))
        await #expect(throws: AuthenticationError.invalidCredentials) {
            try await repository.signIn(with: credentials)
        }
    }

    @Test func signUpWithSessionSignsIn() async throws {
        let repository = DefaultAuthRepository(remoteDataSource: StubAuthRemoteDataSource())
        let result = try await repository.signUp(account)
        #expect(result == .signedIn(AuthUser(id: "user-1", email: "ana@hirekit.app", name: "Ana")))
    }

    @Test func signUpWithoutSessionRequiresConfirmation() async throws {
        let repository = DefaultAuthRepository(remoteDataSource: StubAuthRemoteDataSource(hasSession: false))
        let result = try await repository.signUp(account)
        #expect(result == .confirmationRequired(email: "ana@hirekit.app"))
    }

    @Test func missingConfigurationFailsWithoutNetwork() async {
        let repository = DefaultAuthRepository(remoteDataSource: SupabaseAuthRemoteDataSource(configuration: nil))
        await #expect(throws: AuthenticationError.notConfigured) {
            try await repository.signIn(with: credentials)
        }
        await #expect(throws: AuthenticationError.notConfigured) {
            try await repository.signUp(account)
        }
    }
}
