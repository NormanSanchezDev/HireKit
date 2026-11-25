import SwiftUI

/// The semantic color of an ``HKProgress`` indicator, resolved against the active theme.
public enum HKProgressTone: Sendable, Equatable {
    /// The brand color, for standard progress indicators.
    case primary

    /// The complementary brand color, for secondary progress indicators.
    case secondary

    /// The color that signals a successful or completed state.
    case success

    /// The color that signals attention or approaching limits.
    case warning

    /// The color that signals an error or critical state.
    case error

    func color(in colors: HKColors) -> Color {
        switch self {
        case .primary: colors.primary
        case .secondary: colors.secondary
        case .success: colors.success
        case .warning: colors.warning
        case .error: colors.error
        }
    }
}
