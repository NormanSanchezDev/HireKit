import HKDomain
import Testing

struct OnboardingUseCasesTests {
    private actor InMemoryOnboardingRepository: OnboardingRepository {
        private(set) var state: OnboardingState

        init(state: OnboardingState) {
            self.state = state
        }

        func currentState() -> OnboardingState { state }
        func save(_ state: OnboardingState) { self.state = state }
    }

    @Test(arguments: OnboardingState.allCases)
    func getReturnsStoredState(state: OnboardingState) async {
        let repository = InMemoryOnboardingRepository(state: state)
        #expect(await DefaultGetOnboardingStateUseCase(repository: repository).execute() == state)
    }

    @Test func completeStoresCompleted() async throws {
        let repository = InMemoryOnboardingRepository(state: .pending)
        try await DefaultCompleteOnboardingUseCase(repository: repository).execute()
        #expect(await repository.state == .completed)
    }

    @Test func resetStoresPending() async throws {
        let repository = InMemoryOnboardingRepository(state: .completed)
        try await DefaultResetOnboardingUseCase(repository: repository).execute()
        #expect(await repository.state == .pending)
    }
}
