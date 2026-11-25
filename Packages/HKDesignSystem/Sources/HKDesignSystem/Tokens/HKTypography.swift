import SwiftUI

/// The type scale of the HireKit design system.
///
/// Every style is a Dynamic Type text style, so text grows and shrinks with the
/// user's preferred content size. Avoid fixed point sizes in components.
public struct HKTypography: Sendable {
    /// The style for screen and card titles.
    public let title = Font.title.bold()

    /// The style for section headings and emphasized rows.
    public let headline = Font.headline

    /// The style for secondary headings and supporting copy.
    public let subheadline = Font.subheadline

    /// The style for field titles and other control labels.
    public let fieldLabel = Font.subheadline.bold()

    /// The style for footnotes and legal copy.
    public let footnote = Font.footnote

    /// The style for body text.
    public let body = Font.body

    /// The style for button titles.
    public let button = Font.headline

    /// The style for captions and inline feedback. Use it sparingly.
    public let caption = Font.caption
}
