import SwiftUI

/// Localized text styled with the design system type scale and colors.
///
/// ```swift
/// HKLabel("welcome_title_txt", type: .title, tone: .accent)
///     .accessibilityAddTraits(.isHeader)
///
/// HKLabel("common_updated_today", type: .caption, tone: .secondary)
/// ```
///
/// Every type is a Dynamic Type style, so the label scales with the user's
/// preferred text size.
public struct HKLabel: View {
    @Environment(\.hkTheme) private var theme

    private let model: HKLabelModel

    /// Creates a label from a model.
    ///
    /// - Parameter model: The content and style of the label.
    public init(model: HKLabelModel) {
        self.model = model
    }

    /// Creates a label.
    ///
    /// - Parameters:
    ///   - text: The localized text of the label.
    ///   - type: The typographic role of the label.
    ///   - tone: The semantic color of the label.
    public init(_ text: LocalizedStringKey, type: HKLabelType = .body, tone: HKLabelTone = .primary) {
        self.init(model: HKLabelModel(text: text, type: type, tone: tone))
    }

    public var body: some View {
        Text(model.text)
            .font(model.type.font(in: theme.typography))
            .foregroundStyle(model.tone.color(in: theme.colors))
    }
}

#Preview("Label styles") {
    VStack(alignment: .leading) {
        HKLabel("common_interviews", type: .title, tone: .accent)
        HKLabel("common_next_interview", type: .headline)
        HKLabel("common_interview_details", type: .subheadline)
        HKLabel("common_meet_team")
        HKLabel("common_updated_today", type: .caption, tone: .secondary)
        HKLabel("common_local_times", type: .footnote, tone: .secondary)
    }
    .padding()
}
