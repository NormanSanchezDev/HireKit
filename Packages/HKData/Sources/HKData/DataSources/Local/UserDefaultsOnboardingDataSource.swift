import Foundation

/// An ``OnboardingLocalDataSource`` that stores progress in `UserDefaults`
/// under the `HKData.onboardingState` key.
///
/// `UserDefaults` is thread-safe but not marked `Sendable`, and this type holds
/// no other mutable state, so it is `@unchecked Sendable`.
public final class UserDefaultsOnboardingDataSource: OnboardingLocalDataSource, @unchecked Sendable {
    static let key = "HKData.onboardingState"

    private let defaults: UserDefaults

    /// Creates a data source.
    ///
    /// - Parameter defaults: The defaults database to use. Tests pass an
    ///   isolated suite.
    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// Returns the stored raw value, or `nil` when nothing is stored.
    public func readState() -> String? {
        defaults.string(forKey: Self.key)
    }

    /// Stores a raw value.
    ///
    /// - Parameter rawValue: The raw value of an `OnboardingState`.
    public func writeState(_ rawValue: String) {
        defaults.set(rawValue, forKey: Self.key)
    }
}
