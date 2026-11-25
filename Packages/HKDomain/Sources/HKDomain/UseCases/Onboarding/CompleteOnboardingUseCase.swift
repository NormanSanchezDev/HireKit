/// A use case that marks the welcome flow as finished.
public protocol CompleteOnboardingUseCase: Sendable {
    /// Stores the welcome flow as completed.
    func execute() async throws
}
