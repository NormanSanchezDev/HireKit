import SwiftUI

/// The content and style of an ``HKLabel``.
public struct HKLabelModel {
    /// The localized text of the label.
    public let text: LocalizedStringKey

    /// The typographic role of the label.
    public let type: HKLabelType

    /// The semantic color of the label.
    public let tone: HKLabelTone

    /// Creates a label model.
    ///
    /// - Parameters:
    ///   - text: The localized text of the label.
    ///   - type: The typographic role of the label.
    ///   - tone: The semantic color of the label.
    public init(text: LocalizedStringKey, type: HKLabelType = .body, tone: HKLabelTone = .primary) {
        self.text = text
        self.type = type
        self.tone = tone
    }
}
