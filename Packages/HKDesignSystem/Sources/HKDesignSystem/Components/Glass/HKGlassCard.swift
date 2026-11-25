import SwiftUI

/**
 * Liquid Glass surface for grouping related content.
 * Set `isInteractive` when the whole card responds to touch or pointer input.
 */
public struct HKGlassCard<Content: View>: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    private let isInteractive: Bool
    private let content: Content

    public init(isInteractive: Bool = false, @ViewBuilder content: () -> Content) {
        self.isInteractive = isInteractive
        self.content = content()
    }

    public var body: some View {
        let theme = themeManager.current(for: colorScheme)
        content
            .padding(theme.spacing.extraLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(
                isInteractive ? .regular.interactive() : .regular,
                in: .rect(cornerRadius: theme.radius.large)
            )
    }
}

#Preview("Glass card") {
    HKGlassCard {
        VStack(alignment: .leading) {
            HKLabel(model: .init(text: "Next interview", type: .headline))
            HKLabel(model: .init(text: "Tomorrow, 10:00", type: .caption))
        }
    }
    .padding()
    .hkBackdrop()
    .environment(HKThemeManager(defaults: nil))
}
