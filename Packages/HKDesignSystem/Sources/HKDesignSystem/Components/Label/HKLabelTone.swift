import SwiftUI

/// The semantic color of an ``HKLabel``, resolved against the active theme.
public enum HKLabelTone: Sendable {
    /// The color for primary content.
    case primary

    /// The color for supporting content.
    case secondary

    /// The brand color, for titles and highlights.
    case accent

    func color(in colors: HKColors) -> Color {
        switch self {
        case .primary: colors.textPrimary
        case .secondary: colors.textSecondary
        case .accent: colors.primary
        }
    }
}
