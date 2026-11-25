import Foundation
import Observation
import SwiftUI

/// The observable source of the active theme.
///
/// Create one manager at the composition root and inject it into the
/// environment. Every design system component reads it from there:
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

    /// The theme for the selected mode.
    ///
    /// In system mode the colors adapt where SwiftUI renders them. Prefer
    /// ``current(for:)`` inside views, which also respects the view's
    /// environment.
    public var current: HKTheme {
        HKTheme(colorScheme: selectedMode.colorScheme)
    }

    /// Returns the theme for the selected mode, resolved against a view's
    /// environment.
    ///
    /// - Parameter colorScheme: The color scheme of the calling view, read from
    ///   `@Environment(\.colorScheme)`. It applies only in system mode.
    /// - Returns: The theme to style the view with.
    public func current(for colorScheme: ColorScheme) -> HKTheme {
        HKTheme(colorScheme: selectedMode.colorScheme ?? colorScheme)
    }
}
