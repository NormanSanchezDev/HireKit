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

public struct HKLabelModel {
    public let text: LocalizedStringKey
    public let type: HKLabelType

    public init(text: LocalizedStringKey, type: HKLabelType = .body) {
        self.text = text
        self.type = type
    }
}
