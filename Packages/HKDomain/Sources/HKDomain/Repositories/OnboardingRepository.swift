/// A store for the user's onboarding progress.
///
/// The domain defines the contract and `HKData` implements it, so use cases
/// never know where the value lives.
public protocol OnboardingRepository: Sendable {
    /// Returns the stored progress, or ``OnboardingState/pending`` when nothing
    /// valid is stored.
    func currentState() async -> OnboardingState

    /// Stores new progress.
    ///
    /// - Parameter state: The progress to store.
    func save(_ state: OnboardingState) async throws
}
