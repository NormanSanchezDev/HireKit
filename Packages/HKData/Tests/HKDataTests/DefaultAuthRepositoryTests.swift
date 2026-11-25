import HKData
import HKDomain
import Testing

struct DefaultAuthRepositoryTests {
    private struct StubAuthRemoteDataSource: AuthRemoteDataSource {
        var user = RemoteAuthUser(id: "user-1", email: "ana@hirekit.app", name: "Ana")
        var hasSession = true
        var failure: AuthenticationError?

        func signIn(email: String, password: String) throws(AuthenticationError) -> RemoteAuthUser {
            if let failure { throw failure }
            return user
        }

        func signUp(name: String, email: String, password: String) throws(AuthenticationError) -> RemoteSignUpResponse {
            if let failure { throw failure }
            return RemoteSignUpResponse(user: user, hasSession: hasSession)
        }
    }

    private let credentials = AuthCredentials(email: "ana@hirekit.app", password: "secreta123")

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
        let result = try await repository.signUp(NewAccount(name: "Ana", credentials: credentials))
        #expect(result == .signedIn(AuthUser(id: "user-1", email: "ana@hirekit.app", name: "Ana")))
    }

    @Test func signUpWithoutSessionRequiresConfirmation() async throws {
        let repository = DefaultAuthRepository(remoteDataSource: StubAuthRemoteDataSource(hasSession: false))
        let result = try await repository.signUp(NewAccount(name: "Ana", credentials: credentials))
        #expect(result == .confirmationRequired(email: "ana@hirekit.app"))
    }

    @Test func missingConfigurationFailsWithoutNetwork() async {
        let repository = DefaultAuthRepository(remoteDataSource: SupabaseAuthRemoteDataSource(configuration: nil))
        await #expect(throws: AuthenticationError.notConfigured) {
            try await repository.signIn(with: credentials)
        }
        await #expect(throws: AuthenticationError.notConfigured) {
            try await repository.signUp(NewAccount(name: "Ana", credentials: credentials))
        }
    }
}
