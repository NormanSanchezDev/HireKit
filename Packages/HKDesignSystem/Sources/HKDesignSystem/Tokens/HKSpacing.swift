import Foundation

/// The spacing scale of the HireKit design system, in points.
///
/// Use these values for stack spacing and padding so layouts share one rhythm.
public struct HKSpacing: Sendable {
    /// Four points, for tightly related elements such as an icon and its text.
    public let small: CGFloat = 4

    /// Eight points, the default gap between related controls.
    public let medium: CGFloat = 8

    /// Sixteen points, the gap between groups of content.
    public let large: CGFloat = 16

    /// Twenty-four points, for screen margins and card padding.
    public let extraLarge: CGFloat = 24

    /// The minimum side of any tappable area, as required by the Human Interface Guidelines.
    public let minimumHitTarget: CGFloat = 44
}
