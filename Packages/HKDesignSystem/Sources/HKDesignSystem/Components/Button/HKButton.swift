import SwiftUI

/// A Liquid Glass button that performs an action.
///
/// The primary variant uses prominent glass tinted with the brand color, for
/// the main action of a screen. The secondary variant uses regular glass:
///
/// ```swift
/// HKButton("Apply", systemImage: "paperplane") {
///     viewModel.apply()
/// }
///
/// HKButton("Not now", variant: .secondary) {
///     dismiss()
/// }
/// ```
///
/// While `isLoading` is `true` the button shows a progress indicator, ignores
/// taps and tells VoiceOver that it is busy. Keep one primary button per
/// screen, and group adjacent buttons in ``HKGlassGroup``.
public struct HKButton: View {
    /// The visual prominence of a button.
    public enum Variant: Sendable {
        /// Prominent glass tinted with the brand color, for the main action.
        case primary

        /// Regular glass, for secondary and cancel actions.
        case secondary
    }

    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    private let title: LocalizedStringKey
    private let systemImage: String?
    private let variant: Variant
    private let isLoading: Bool
    private let action: () -> Void

    /// Creates a button.
    ///
    /// - Parameters:
    ///   - title: The localized title of the button. VoiceOver reads it even
    ///     when only the icon is visible.
    ///   - systemImage: The name of an SF Symbol shown before the title.
    ///   - variant: The visual prominence of the button.
    ///   - isLoading: Whether the action is in progress.
    ///   - action: The action to perform when the user triggers the button.
    public init(
        _ title: LocalizedStringKey,
        systemImage: String? = nil,
        variant: Variant = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.variant = variant
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        let theme = themeManager.current(for: colorScheme)
        let button = Button(action: action) {
            HStack(spacing: theme.spacing.medium) {
                if isLoading {
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
        .accessibilityValue(isLoading ? Text("Cargando") : Text(""))
        .disabled(isLoading)

        switch variant {
        case .primary: button.buttonStyle(.glassProminent).tint(theme.colors.primary)
        case .secondary: button.buttonStyle(.glass)
        }
    }

    @ViewBuilder
    private var label: some View {
        if let systemImage, !isLoading {
            Label(title, systemImage: systemImage)
        } else {
            Text(title)
        }
    }
}

#Preview("Button") {
    HKGlassGroup(spacing: 12) {
        VStack(spacing: 12) {
            HKButton("Continue") {}
            HKButton("Apply", systemImage: "paperplane") {}
            HKButton("Cancel", variant: .secondary) {}
        }
    }
    .padding()
    .hkBackdrop()
    .environment(HKThemeManager(defaults: nil))
}
