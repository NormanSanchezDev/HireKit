/// The progress of the user through the welcome flow.
public enum OnboardingState: String, Sendable, Equatable, CaseIterable {
    /// The user has not finished the welcome flow, so the app shows it on launch.
    case pending

    /// The user finished the welcome flow.
    case completed
}
