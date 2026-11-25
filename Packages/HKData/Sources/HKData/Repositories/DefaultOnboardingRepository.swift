import HKDomain

/**
 * `OnboardingRepository` backed by a local data source. Unknown or missing
 * values map to `.pending` so a corrupted value never skips the welcome flow.
 */
public struct DefaultOnboardingRepository: OnboardingRepository {
    private let localDataSource: any OnboardingLocalDataSource

    public init(localDataSource: any OnboardingLocalDataSource) {
        self.localDataSource = localDataSource
    }

    public func currentState() async -> OnboardingState {
        localDataSource.readState().flatMap(OnboardingState.init(rawValue:)) ?? .pending
    }

    public func save(_ state: OnboardingState) async throws {
        localDataSource.writeState(state.rawValue)
    }
}
