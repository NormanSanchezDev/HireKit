/// The default ``CompleteOnboardingUseCase``, which saves ``OnboardingState/completed``.
public struct DefaultCompleteOnboardingUseCase: CompleteOnboardingUseCase {
    private let repository: any OnboardingRepository

    /// Creates the use case.
    ///
    /// - Parameter repository: The store for onboarding progress.
    public init(repository: any OnboardingRepository) {
        self.repository = repository
    }

    /// Stores the welcome flow as completed.
    public func execute() async throws {
        try await repository.save(.completed)
    }
}
