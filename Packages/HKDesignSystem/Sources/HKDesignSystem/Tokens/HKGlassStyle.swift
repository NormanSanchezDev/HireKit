import SwiftUI

/// The Liquid Glass material that a design system surface uses.
///
/// Pick the style by how much the surface should stand out from the content
/// behind it:
///
/// ```swift
/// HKGlassCard(style: .tinted(.indigo)) {
///     Text("Interview tomorrow")
/// }
/// ```
///
/// Glass needs colorful content behind it to refract. Place glass surfaces over
/// ``HKBackground`` or over real content, not over a flat background.
public enum HKGlassStyle: Hashable, Sendable {
    /// The standard glass material, legible over any content.
    case regular

    /// A more transparent material for surfaces over rich media.
    case clear

    /// The standard material tinted with a color, to highlight a surface.
    case tinted(Color)

    /// Returns the SwiftUI glass that this style describes.
    ///
    /// - Parameter isInteractive: Whether the glass reacts to touch and pointer
    ///   input, by scaling and shimmering under the finger or cursor.
    /// - Returns: A glass value to pass to `glassEffect(_:in:)`.
    public func glass(isInteractive: Bool = false) -> Glass {
        base.interactive(isInteractive)
    }

    private var base: Glass {
        switch self {
        case .regular: .regular
        case .clear: .clear
        case .tinted(let color): .regular.tint(color)
        }
    }
}
