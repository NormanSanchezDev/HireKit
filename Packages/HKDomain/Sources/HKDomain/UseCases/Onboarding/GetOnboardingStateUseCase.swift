/// A use case that reads whether the welcome flow is still pending.
public protocol GetOnboardingStateUseCase: Sendable {
    /// Returns the user's current onboarding progress.
    func execute() async -> OnboardingState
}
