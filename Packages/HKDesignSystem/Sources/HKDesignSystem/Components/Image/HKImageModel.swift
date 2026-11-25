import SwiftUI

/// The content and configuration of an ``HKImage``.
public struct HKImageModel {
    /// The place the image loads from.
    public let source: HKImageSource

    /// How the image fills the space that its parent proposes.
    public let contentMode: ContentMode

    /// The color of SF Symbols and of assets rendered as templates.
    public let tint: Color?

    /// The description that VoiceOver reads, or `nil` for a decorative image.
    public let accessibilityLabel: LocalizedStringKey?

    /// Creates an image model.
    ///
    /// - Parameters:
    ///   - source: The place the image loads from.
    ///   - contentMode: How the image fills the proposed space.
    ///   - tint: The color of SF Symbols. For other sources, a tint renders the
    ///     image as a single-color template.
    ///   - accessibilityLabel: The description that VoiceOver reads. Leave it
    ///     `nil` for decorative images, so VoiceOver skips them.
    public init(
        source: HKImageSource,
        contentMode: ContentMode = .fit,
        tint: Color? = nil,
        accessibilityLabel: LocalizedStringKey? = nil
    ) {
        self.source = source
        self.contentMode = contentMode
        self.tint = tint
        self.accessibilityLabel = accessibilityLabel
    }
}
