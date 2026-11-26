import Foundation
import HKDomain

actor StubAuthUseCases: SignInUseCase, SignUpUseCase {
    private let failure: AuthenticationError?
    private let signUpResult: SignUpResult
    private(set) var receivedCredentials: AuthCredentials?
    private(set) var receivedAccount: NewAccount?
    private(set) var signUpCallCount = 0

    init(failure: AuthenticationError? = nil, signUpResult: SignUpResult = .signedIn(.sample)) {
        self.failure = failure
        self.signUpResult = signUpResult
    }

    func execute(_ credentials: AuthCredentials) throws(AuthenticationError) -> AuthUser {
        receivedCredentials = credentials
        if let failure { throw failure }
        return .sample
    }

    func execute(_ account: NewAccount) throws(AuthenticationError) -> SignUpResult {
        signUpCallCount += 1
        receivedAccount = account
        if let failure { throw failure }
        return signUpResult
    }
}

extension AuthUser {
    static let sample = AuthUser(id: "user-1", email: "ana@hirekit.app", name: "Ana")
}

actor ManualSleeper {
    private var sleepers: [CheckedContinuation<Void, any Error>] = []
    private(set) var sleepCount = 0

    func sleep(_ duration: Duration) async throws {
        sleepCount += 1
        try await withCheckedThrowingContinuation { sleepers.append($0) }
    }

    func wakeAll() {
        let waking = sleepers
        sleepers = []
        waking.forEach { $0.resume() }
    }
}

enum SignUpFixtures {
    static let today = Date(timeIntervalSince1970: 1_795_000_000)
    static let adultBirthDate = Date(timeIntervalSince1970: 631_152_000)
    static let phoneDigits = "5625068370"

    static let personal = PersonalInformation(
        firstName: "Ana",
        paternalLastName: "López",
        maternalLastName: "",
        birthDate: adultBirthDate
    )
}

@MainActor
func waitUntil(_ condition: @MainActor () async -> Bool) async {
    for _ in 0..<1_000 {
        if await condition() { return }
        await Task.yield()
    }
}
