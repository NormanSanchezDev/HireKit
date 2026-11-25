/// The default ``ResetOnboardingUseCase``, which saves ``OnboardingState/pending``.
public struct DefaultResetOnboardingUseCase: ResetOnboardingUseCase {
    private let repository: any OnboardingRepository

    /// Creates the use case.
    ///
    /// - Parameter repository: The store for onboarding progress.
    public init(repository: any OnboardingRepository) {
        self.repository = repository
    }

    /// Stores the welcome flow as pending again.
    public func execute() async throws {
        try await repository.save(.pending)
    }
}
