import SwiftUI

/// The localized prompt and action shown by ``HKActionPrompt``.
public struct HKActionPromptModel {
    /// The supporting prompt displayed before the action.
    public let prompt: HKLabelModel

    /// The localized title of the action.
    public let actionTitle: LocalizedStringKey

    /// Creates an action prompt.
    ///
    /// - Parameters:
    ///   - prompt: The supporting text and style.
    ///   - actionTitle: The localized action title.
    public init(prompt: HKLabelModel, actionTitle: LocalizedStringKey) {
        self.prompt = prompt
        self.actionTitle = actionTitle
    }
}
