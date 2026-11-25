/**
 * Whether the user has already gone through the welcome flow.
 */
public enum OnboardingState: String, Sendable, Equatable, CaseIterable {
    case pending
    case completed
}
