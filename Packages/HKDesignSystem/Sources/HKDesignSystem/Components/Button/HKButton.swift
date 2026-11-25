import SwiftUI

/// A Liquid Glass button that performs an action.
///
/// Configure the title, appearance and action with ``HKButtonModel``:
///
/// ```swift
/// HKButton(model: .init(title: "common_apply", systemImage: "paperplane") {
///     viewModel.apply()
/// })
/// ```
///
/// While `isLoading` is `true` the button shows a progress indicator, ignores
/// taps and tells VoiceOver that it is busy. Keep one primary button per
/// screen, and group adjacent buttons in ``HKGlassGroup``.
public struct HKButton: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    private let model: HKButtonModel

    /// Creates a button from its configuration.
    ///
    /// - Parameter model: The button's content, appearance and action.
    public init(model: HKButtonModel) {
        self.model = model
    }

    public var body: some View {
        let theme = themeManager.current(for: colorScheme)
        let button = Button(action: model.action) {
            HStack(spacing: theme.spacing.medium) {
                if model.isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .accessibilityHidden(true)
                }
                label
                    .font(theme.typography.button)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(minWidth: theme.spacing.minimumHitTarget, minHeight: theme.spacing.minimumHitTarget)
        }
        .accessibilityValue(model.isLoading ? Text("common_loading") : Text(verbatim: ""))
        .disabled(model.isLoading || !model.isEnabled)

        switch model.type {
        case .filled: button.buttonStyle(.glassProminent).tint(theme.colors.primary)
        case .outline: button.buttonStyle(.glass)
        case .text: button.buttonStyle(.borderless).tint(theme.colors.primary)
        }
    }

    @ViewBuilder
    private var label: some View {
        if let systemImage = model.systemImage, !model.isLoading {
            Label(model.title, systemImage: systemImage)
        } else {
            Text(model.title)
        }
    }
}

#Preview("Button states") {
    HKGlassGroup(spacing: 12) {
        VStack(spacing: 12) {
            HKButton(model: .init(title: "common_continue") {})
            HKButton(model: .init(title: "common_apply", systemImage: "paperplane") {})
            HKButton(model: .init(title: "common_cancel", variant: .outline) {})
            HKButton(model: .init(title: "common_learn_more", variant: .text) {})
            HKButton(model: .init(title: "common_saving", isLoading: true) {})
            HKButton(model: .init(title: "common_unavailable", isEnabled: false) {})
        }
    }
    .padding()
    .hkBackground()
    .environment(HKThemeManager(defaults: nil))
}

#Preview("Button, dark and large text") {
    HKGlassGroup(spacing: 12) {
        VStack(spacing: 12) {
            HKButton(model: .init(title: "common_continue") {})
            HKButton(model: .init(title: "common_cancel", variant: .outline) {})
        }
    }
    .padding()
    .hkBackground()
    .environment(HKThemeManager(defaults: nil))
    .environment(\.dynamicTypeSize, .accessibility3)
    .preferredColorScheme(.dark)
}
