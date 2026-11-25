import HKDomain
import Testing

struct AuthUseCasesTests {
    private actor RecordingAuthRepository: AuthRepository {
        private(set) var signedInCredentials: AuthCredentials?
        private(set) var createdAccount: NewAccount?
        private let failure: AuthenticationError?

        init(failure: AuthenticationError? = nil) {
            self.failure = failure
        }

        func signIn(with credentials: AuthCredentials) throws(AuthenticationError) -> AuthUser {
            signedInCredentials = credentials
            if let failure { throw failure }
            return AuthUser(id: "user-1", email: credentials.email)
        }

        func signUp(_ account: NewAccount) throws(AuthenticationError) -> SignUpResult {
            createdAccount = account
            if let failure { throw failure }
            return .confirmationRequired(email: account.credentials.email)
        }
    }

    @Test func signInNormalizesEmailAndKeepsPassword() async throws {
        let repository = RecordingAuthRepository()
        let user = try await DefaultSignInUseCase(repository: repository)
            .execute(AuthCredentials(email: "  Ana@HireKit.App \n", password: " Secreta 1 "))
        let expected = AuthCredentials(email: "ana@hirekit.app", password: " Secreta 1 ")
        #expect(await repository.signedInCredentials == expected)
        #expect(user.email == "ana@hirekit.app")
    }

    @Test(arguments: AuthenticationError.allCases)
    func signInPropagatesRepositoryErrors(error: AuthenticationError) async {
        let useCase = DefaultSignInUseCase(repository: RecordingAuthRepository(failure: error))
        await #expect(throws: error) {
            try await useCase.execute(AuthCredentials(email: "ana@hirekit.app", password: "secreta123"))
        }
    }

    @Test func signUpNormalizesNameAndEmail() async throws {
        let repository = RecordingAuthRepository()
        let result = try await DefaultSignUpUseCase(repository: repository).execute(NewAccount(
            name: "  Ana  ",
            credentials: AuthCredentials(email: " ANA@hirekit.app ", password: "secreta123")
        ))
        let expected = NewAccount(
            name: "Ana",
            credentials: AuthCredentials(email: "ana@hirekit.app", password: "secreta123")
        )
        #expect(await repository.createdAccount == expected)
        #expect(result == .confirmationRequired(email: "ana@hirekit.app"))
    }

    @Test func signUpPropagatesRepositoryErrors() async {
        let useCase = DefaultSignUpUseCase(repository: RecordingAuthRepository(failure: .emailAlreadyRegistered))
        await #expect(throws: AuthenticationError.emailAlreadyRegistered) {
            try await useCase.execute(NewAccount(
                name: "Ana",
                credentials: AuthCredentials(email: "ana@hirekit.app", password: "secreta123")
            ))
        }
    }
}
