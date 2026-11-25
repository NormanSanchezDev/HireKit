import SwiftUI

/// The appearance that the user chose for the app.
public enum HKThemeMode: String, Codable, CaseIterable, Sendable {
    /// Follows the system appearance.
    case system

    /// Always uses the light appearance.
    case light

    /// Always uses the dark appearance.
    case dark

    /// The color scheme to force, or `nil` to follow the system.
    ///
    /// Pass it to `preferredColorScheme(_:)` at the root of the app.
    public var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}
