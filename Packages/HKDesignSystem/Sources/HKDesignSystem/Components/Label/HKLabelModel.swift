import SwiftUI

public enum HKLabelType: Sendable {
    case headline
    case title
    case subheadline
    case body
    case caption
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

/**
 * Semantic text color, resolved against the active theme.
 */
public enum HKLabelTone: Sendable {
    case primary
    case secondary
    case accent

    func color(in colors: HKColors) -> Color {
        switch self {
        case .primary: colors.textPrimary
        case .secondary: colors.textSecondary
        case .accent: colors.primary
        }
    }
}

public struct HKLabelModel {
    public let text: LocalizedStringKey
    public let type: HKLabelType
    public let tone: HKLabelTone

    public init(text: LocalizedStringKey, type: HKLabelType = .body, tone: HKLabelTone = .primary) {
        self.text = text
        self.type = type
        self.tone = tone
    }
}
