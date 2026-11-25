import SwiftUI

public struct HKButton: View {
    public enum Variant: Sendable {
        case primary
        case secondary
    }

    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    private let title: LocalizedStringKey
    private let variant: Variant
    private let isLoading: Bool
    private let action: () -> Void

    public init(
        _ title: LocalizedStringKey,
        variant: Variant = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
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
                Text(title)
                    .font(theme.typography.button)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(minWidth: theme.spacing.minimumHitTarget, minHeight: theme.spacing.minimumHitTarget)
        }
        .accessibilityValue(isLoading ? Text("Loading") : Text(""))
        .disabled(isLoading)

        if #available(iOS 26, macOS 26, *) {
            switch variant {
            case .primary: button.buttonStyle(.glassProminent).tint(theme.colors.primary)
            case .secondary: button.buttonStyle(.glass)
            }
        } else {
            switch variant {
            case .primary: button.buttonStyle(.borderedProminent).tint(theme.colors.primary)
            case .secondary: button.buttonStyle(.bordered)
            }
        }
    }
}

#Preview("Primary button") {
    HKButton("Continue") {}
        .padding()
        .environment(HKThemeManager(defaults: nil))
}
