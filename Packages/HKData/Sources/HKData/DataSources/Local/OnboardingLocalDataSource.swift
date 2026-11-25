import Foundation

/// Raw storage for onboarding progress. Works with primitive values so the
/// repository owns the mapping to domain types.
public protocol OnboardingLocalDataSource: Sendable {
    func readState() -> String?
    func writeState(_ rawValue: String)
}

/// Stores onboarding progress in `UserDefaults` under `HKData.onboardingState`.
/// `UserDefaults` is documented as thread-safe but is not marked `Sendable`,
/// and this type holds no other mutable state, hence `@unchecked Sendable`.
public final class UserDefaultsOnboardingDataSource: OnboardingLocalDataSource, @unchecked Sendable {
    static let key = "HKData.onboardingState"
    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func readState() -> String? {
        defaults.string(forKey: Self.key)
    }

    public func writeState(_ rawValue: String) {
        defaults.set(rawValue, forKey: Self.key)
    }
}
