/// A use case that brings the welcome flow back, for example from Settings.
public protocol ResetOnboardingUseCase: Sendable {
    /// Stores the welcome flow as pending again.
    func execute() async throws
}
