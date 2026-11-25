/// The default ``GetOnboardingStateUseCase``, which reads from an ``OnboardingRepository``.
public struct DefaultGetOnboardingStateUseCase: GetOnboardingStateUseCase {
    private let repository: any OnboardingRepository

    /// Creates the use case.
    ///
    /// - Parameter repository: The store for onboarding progress.
    public init(repository: any OnboardingRepository) {
        self.repository = repository
    }

    /// Returns the user's current onboarding progress.
    public func execute() async -> OnboardingState {
        await repository.currentState()
    }
}
