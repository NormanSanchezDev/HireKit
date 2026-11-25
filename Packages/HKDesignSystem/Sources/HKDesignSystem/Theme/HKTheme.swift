import SwiftUI

/// The design tokens of HireKit: colors, typography, spacing and corner radii.
///
/// Read the theme from the environment in any view. Colors come from the asset
/// catalog, so they already adapt to light, dark and Increase Contrast:
///
/// ```swift
/// struct OfferRow: View {
///     @Environment(\.hkTheme) private var theme
///
///     var body: some View {
///         Text("Offer accepted")
///             .foregroundStyle(theme.colors.success)
///             .padding(theme.spacing.medium)
///     }
/// }
/// ```
///
/// The light or dark choice lives in ``HKThemeManager``, which the app root
/// applies with `preferredColorScheme(_:)`.
public struct HKTheme: Sendable {
    /// The semantic colors of the theme.
    public let colors = HKColors()

    /// The Dynamic Type styles of the theme.
    public let typography = HKTypography()

    /// The spacing scale of the theme.
    public let spacing = HKSpacing()

    /// The corner radius scale of the theme.
    public let radius = HKRadius()

    /// Creates the HireKit theme.
    public init() {}
}
