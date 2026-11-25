import SwiftUI

/// A supporting label paired with a prominent inline action.
///
/// Use this for prompts such as account creation below an authentication form.
public struct HKActionPrompt: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    private let model: HKActionPromptModel
    private let action: () -> Void

    /// Creates an action prompt.
    ///
    /// - Parameters:
    ///   - model: The supporting text and action title.
    ///   - action: The action to perform when the prompt button is activated.
    public init(model: HKActionPromptModel, action: @escaping () -> Void) {
        self.model = model
        self.action = action
    }

    public var body: some View {
        let theme = themeManager.current(for: colorScheme)
        HStack(spacing: theme.spacing.small) {
            HKLabel(model: model.prompt)
            Button(model.actionTitle, action: action)
                .buttonStyle(.plain)
                .foregroundStyle(theme.colors.primary)
                .frame(minHeight: theme.spacing.minimumHitTarget)
        }
    }
}
