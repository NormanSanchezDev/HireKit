import SwiftUI

/// The typographic role of an ``HKLabel``.
public enum HKLabelType: Sendable {
    /// A section heading or an emphasized row.
    case headline

    /// A screen or card title.
    case title

    /// A secondary heading or supporting copy.
    case subheadline

    /// Body text.
    case body

    /// A caption. Use it sparingly, it is small.
    case caption

    /// A footnote or legal copy.
    case footnote

    func font(in typography: HKTypography) -> Font {
        switch self {
        case .headline: typography.headline
        case .title: typography.title
        case .subheadline: typography.subheadline
        case .body: typography.body
        case .caption: typography.caption
        case .footnote: typography.footnote
        }
    }
}
