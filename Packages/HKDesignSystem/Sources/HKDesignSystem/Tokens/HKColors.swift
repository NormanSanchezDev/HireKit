import SwiftUI

/// The semantic color palette of the HireKit design system.
///
/// Read colors through ``HKTheme`` instead of hard-coding them:
///
/// ```swift
/// @Environment(\.hkTheme) private var theme
///
/// Text("Offer accepted")
///     .foregroundStyle(theme.colors.success)
/// ```
///
/// Every color comes from the asset catalog, so it adapts to light, dark and
/// Increase Contrast where SwiftUI renders it.
public struct HKColors: Sendable {

    /// The brand color for prominent actions, selection and accents.
    public var primary: Color { Color("HKPrimary", bundle: .module) }

    /// A complementary brand color for secondary accents and backdrops.
    public var secondary: Color { Color("HKSecondary", bundle: .module) }

    /// The color for primary text content.
    public var textPrimary: Color { Color("HKTextPrimary", bundle: .module) }

    /// The color for supporting text, such as captions and hints.
    public var textSecondary: Color { Color("HKTextSecondary", bundle: .module) }

    /// The color for low-emphasis content.
    public var textTertiary: Color { Color("HKTextTertiary", bundle: .module) }

    /// The color that signals a successful outcome.
    public var success: Color { Color("HKSuccess", bundle: .module) }

    /// The color that signals a condition that needs attention.
    public var warning: Color { Color("HKWarning", bundle: .module) }

    /// The color that signals an error or a destructive outcome.
    public var error: Color { Color("HKError", bundle: .module) }

    /// The color of the window background behind all content.
    public var background: Color { Color("HKBackground", bundle: .module) }

    /// The color of opaque surfaces that sit above the background.
    public var surface: Color { Color("HKSurface", bundle: .module) }

    #if os(macOS)
    /// The color of hairlines and outlines.
    public var border: Color { Color(nsColor: .separatorColor) }
    #else
    /// The color of hairlines and outlines.
    public var border: Color { Color(uiColor: .separator) }
    #endif
}
