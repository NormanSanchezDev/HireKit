import Foundation

/// The corner radius scale of the HireKit design system, in points.
///
/// Shapes built with these radii use continuous corners, matching the
/// concentric look of Liquid Glass.
public struct HKRadius: Sendable {
    /// Eight points, for small elements such as badges.
    public let small: CGFloat = 8

    /// Twelve points, for controls such as text fields.
    public let medium: CGFloat = 12

    /// Twenty points, for cards and other large surfaces.
    public let large: CGFloat = 20
}
