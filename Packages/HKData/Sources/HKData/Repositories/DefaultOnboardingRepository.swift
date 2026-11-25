import HKDomain

/// An `OnboardingRepository` backed by an ``OnboardingLocalDataSource``.
///
/// Missing or unknown values map to `.pending`, so a corrupted value never
/// skips the welcome flow.
public struct DefaultOnboardingRepository: OnboardingRepository {
    private let localDataSource: any OnboardingLocalDataSource

    /// Creates a repository.
    ///
    /// - Parameter localDataSource: The raw storage to read and write.
    public init(localDataSource: any OnboardingLocalDataSource) {
        self.localDataSource = localDataSource
    }

    /// Returns the stored progress, or `.pending` when nothing valid is stored.
    public func currentState() async -> OnboardingState {
        localDataSource.readState().flatMap(OnboardingState.init(rawValue:)) ?? .pending
    }

    /// Stores new progress.
    ///
    /// - Parameter state: The progress to store.
    public func save(_ state: OnboardingState) async throws {
        localDataSource.writeState(state.rawValue)
    }
}
