import Foundation
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

    private static let birthDate = Date(timeIntervalSince1970: 631_152_000)
    private static let phone = PhoneNumber(dialCode: .mexico, digits: "5625068370")!

    private func account(
        firstName: String = "Ana",
        paternal: String = "López",
        maternal: String? = nil,
        email: String = "ana@hirekit.app"
    ) -> NewAccount {
        NewAccount(
            firstName: firstName,
            paternalLastName: paternal,
            maternalLastName: maternal,
            birthDate: Self.birthDate,
            phone: Self.phone,
            credentials: AuthCredentials(email: email, password: "secreta123")
        )
    }

    @Test func signUpCleansNamesAndNormalizesEmail() async throws {
        let repository = RecordingAuthRepository()
        let result = try await DefaultSignUpUseCase(repository: repository)
            .execute(account(firstName: " CArlos. arTURO ", paternal: "lópez", maternal: "  ", email: " ANA@hirekit.app "))
        let expected = account(firstName: "Carlos Arturo", paternal: "López", maternal: nil)
        #expect(await repository.createdAccount == expected)
        #expect(result == .confirmationRequired(email: "ana@hirekit.app"))
    }

    @Test func newAccountCombinesBothSignUpSteps() throws {
        let personal = PersonalInformation(firstName: "Ana", paternalLastName: "López", birthDate: Self.birthDate)
        let contact = ContactInformation(email: "ana@hirekit.app", phone: Self.phone, password: "secreta123")
        let combined = try #require(NewAccount(personal: personal, contact: contact))
        #expect(combined == account())
    }

    @Test func newAccountKeepsMaternalSurnameAndNeedsBirthDate() {
        let contact = ContactInformation(email: "ana@hirekit.app", phone: Self.phone, password: "secreta123")
        let withMaternal = PersonalInformation(
            firstName: "Ana",
            paternalLastName: "López",
            maternalLastName: "Cruz",
            birthDate: Self.birthDate
        )
        #expect(NewAccount(personal: withMaternal, contact: contact)?.maternalLastName == "Cruz")
        #expect(NewAccount(personal: PersonalInformation(firstName: "Ana"), contact: contact) == nil)
    }

    @Test func signUpPropagatesRepositoryErrors() async {
        let useCase = DefaultSignUpUseCase(repository: RecordingAuthRepository(failure: .emailAlreadyRegistered))
        await #expect(throws: AuthenticationError.emailAlreadyRegistered) {
            try await useCase.execute(account())
        }
    }
}
