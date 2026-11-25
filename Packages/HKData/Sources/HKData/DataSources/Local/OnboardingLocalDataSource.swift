/// Raw local storage for onboarding progress.
///
/// It works with primitive values, so the repository owns the mapping to
/// domain types.
public protocol OnboardingLocalDataSource: Sendable {
    /// Returns the stored raw value, or `nil` when nothing is stored.
    func readState() -> String?

    /// Stores a raw value.
    ///
    /// - Parameter rawValue: The raw value of an `OnboardingState`.
    func writeState(_ rawValue: String)
}
