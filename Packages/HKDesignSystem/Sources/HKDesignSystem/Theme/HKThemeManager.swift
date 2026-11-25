import Foundation
import Observation
import SwiftUI

/// The appearance the user chose: system, light or dark.
///
/// Create one manager at the composition root, inject it into the environment
/// and apply its mode with `preferredColorScheme(_:)`. Views do not need it to
/// style themselves; they read ``HKTheme`` from `\.hkTheme`. Only settings
/// screens that change the appearance read the manager:
///
/// ```swift
/// @main
/// struct HireKitApp: App {
///     @State private var themeManager = HKThemeManager()
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .environment(themeManager)
///                 .preferredColorScheme(themeManager.selectedMode.colorScheme)
///         }
///     }
/// }
/// ```
///
/// Changes to ``selectedMode`` are saved to `UserDefaults` and restored on the
/// next launch.
@MainActor
@Observable
public final class HKThemeManager {
    private static let preferenceKey = "HKDesignSystem.themeMode"
    private let defaults: UserDefaults?

    /// The appearance the user chose. Setting it saves the choice.
    public var selectedMode: HKThemeMode {
        didSet {
            defaults?.set(selectedMode.rawValue, forKey: Self.preferenceKey)
        }
    }

    /// Creates a theme manager that restores the saved appearance.
    ///
    /// - Parameter defaults: The store that keeps the user's choice. Pass `nil`
    ///   for an in-memory manager, for example in previews and tests.
    public init(defaults: UserDefaults? = .standard) {
        self.defaults = defaults
        selectedMode = defaults?.string(forKey: Self.preferenceKey)
            .flatMap(HKThemeMode.init(rawValue:)) ?? .system
    }
}
