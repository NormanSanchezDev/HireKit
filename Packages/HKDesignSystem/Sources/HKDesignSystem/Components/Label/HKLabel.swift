import SwiftUI

/// Localized text styled with the design system type scale and colors.
///
/// ```swift
/// HKLabel("Bienvenido a HireKit", type: .title, tone: .accent)
///     .accessibilityAddTraits(.isHeader)
///
/// HKLabel("Actualizado hoy", type: .caption, tone: .secondary)
/// ```
///
/// Every type is a Dynamic Type style, so the label scales with the user's
/// preferred text size.
public struct HKLabel: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

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
        let theme = themeManager.current(for: colorScheme)
        Text(model.text)
            .font(model.type.font(in: theme.typography))
            .foregroundStyle(model.tone.color(in: theme.colors))
    }
}

#Preview("Label styles") {
    VStack(alignment: .leading) {
        HKLabel("Interviews", type: .title, tone: .accent)
        HKLabel("Next interview", type: .headline)
        HKLabel("Interview details", type: .subheadline)
        HKLabel("Meet the hiring team")
        HKLabel("Updated today", type: .caption, tone: .secondary)
        HKLabel("All times are local", type: .footnote, tone: .secondary)
    }
    .padding()
    .environment(HKThemeManager(defaults: nil))
}
