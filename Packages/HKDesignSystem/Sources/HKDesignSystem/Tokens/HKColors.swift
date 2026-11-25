import SwiftUI

/// The semantic color palette of the HireKit design system.
///
/// Read colors through the active theme instead of hard-coding them, so every
/// surface follows the user's appearance preference:
///
/// ```swift
/// let colors = themeManager.current(for: colorScheme).colors
/// Text("Offer accepted")
///     .foregroundStyle(colors.success)
/// ```
///
/// When the theme is pinned to light or dark, each color resolves in that
/// appearance while keeping the caller's other environment settings, such as
/// Increase Contrast. In system mode the colors adapt where SwiftUI renders them.
public struct HKColors: Sendable {
    let colorScheme: ColorScheme?

    /// The brand color for prominent actions, selection and accents.
    public var primary: Color { themed(.indigo) }

    /// A complementary brand color for secondary accents and backdrops.
    public var secondary: Color { themed(.teal) }

    /// The color for primary text content.
    public var textPrimary: Color { themed(.primary) }

    /// The color for supporting text, such as captions and hints.
    public var textSecondary: Color { themed(.secondary) }

    /// The color that signals a successful outcome.
    public var success: Color { themed(.green) }

    /// The color that signals a condition that needs attention.
    public var warning: Color { themed(.orange) }

    /// The color that signals an error or a destructive outcome.
    public var error: Color { themed(.red) }

    #if os(macOS)
    /// The color of the window background behind all content.
    public var background: Color { themed(Color(nsColor: .windowBackgroundColor)) }

    /// The color of opaque surfaces that sit above the background.
    public var surface: Color { themed(Color(nsColor: .controlBackgroundColor)) }

    /// The color of hairlines and outlines.
    public var border: Color { themed(Color(nsColor: .separatorColor)) }
    #else
    /// The color of the window background behind all content.
    public var background: Color { themed(Color(uiColor: .systemBackground)) }

    /// The color of opaque surfaces that sit above the background.
    public var surface: Color { themed(Color(uiColor: .secondarySystemBackground)) }

    /// The color of hairlines and outlines.
    public var border: Color { themed(Color(uiColor: .separator)) }
    #endif

    private func themed(_ color: Color) -> Color {
        guard let colorScheme else { return color }
        return Color(AppearanceColor(base: color, scheme: colorScheme))
    }
}

/// A shape style that resolves a color in a fixed appearance while keeping the
/// caller's contrast and other environment settings.
private struct AppearanceColor: ShapeStyle, Hashable {
    let base: Color
    let scheme: ColorScheme

    func resolve(in environment: EnvironmentValues) -> Color.Resolved {
        var values = environment
        values.colorScheme = scheme
        return base.resolve(in: values)
    }
}
