import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
public final class HKThemeManager {
    private static let preferenceKey = "HKDesignSystem.themeMode"
    private let defaults: UserDefaults?

    public var selectedMode: HKThemeMode {
        didSet {
            defaults?.set(selectedMode.rawValue, forKey: Self.preferenceKey)
        }
    }

    /**
     * Pass nil for an in-memory manager, for example in previews.
     */
    public init(defaults: UserDefaults? = .standard) {
        self.defaults = defaults
        selectedMode = defaults?.string(forKey: Self.preferenceKey)
            .flatMap(HKThemeMode.init(rawValue:)) ?? .system
    }

    /**
     * In system mode, these colors adapt at the point where SwiftUI renders them.
     */
    public var current: HKTheme {
        HKTheme(colorScheme: selectedMode.colorScheme)
    }

    /**
     * Resolves the preference against the calling view’s live environment.
     */
    public func current(for colorScheme: ColorScheme) -> HKTheme {
        HKTheme(colorScheme: selectedMode.colorScheme ?? colorScheme)
    }
}
