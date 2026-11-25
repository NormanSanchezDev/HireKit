import SwiftUI

/// A complete set of design tokens resolved for one appearance.
///
/// Get a theme from ``HKThemeManager`` instead of creating one:
///
/// ```swift
/// let theme = themeManager.current(for: colorScheme)
/// VStack(spacing: theme.spacing.large) { ... }
///     .padding(theme.spacing.extraLarge)
/// ```
public struct HKTheme: Sendable {
    /// The semantic colors of the theme.
    public let colors: HKColors

    /// The Dynamic Type styles of the theme.
    public let typography = HKTypography()

    /// The spacing scale of the theme.
    public let spacing = HKSpacing()

    /// The corner radius scale of the theme.
    public let radius = HKRadius()

    init(colorScheme: ColorScheme?) {
        colors = HKColors(colorScheme: colorScheme)
    }
}
