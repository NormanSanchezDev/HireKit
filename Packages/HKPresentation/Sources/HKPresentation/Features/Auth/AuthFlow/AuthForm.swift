import HKDesignSystem
import SwiftUI

/// The shared layout of the auth screens: fields on a glass card, actions
/// below, with a capped width that reads well on iPad and Mac.
struct AuthForm<Fields: View, Actions: View>: View {
    @Environment(\.hkTheme) private var theme

    private let fields: Fields
    private let actions: Actions
    private let centersContent: Bool

    init(
        centersContent: Bool = false,
        @ViewBuilder fields: () -> Fields,
        @ViewBuilder actions: () -> Actions
    ) {
        self.centersContent = centersContent
        self.fields = fields()
        self.actions = actions()
    }

    var body: some View {
        let spacing = theme.spacing
        Group {
            if centersContent {
                GeometryReader { geometry in
                    form(spacing: spacing, availableHeight: geometry.size.height)
                }
            } else {
                form(spacing: spacing, availableHeight: nil)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .hkBackground()
    }

    private func form(spacing: HKSpacing, availableHeight: CGFloat?) -> some View {
        ScrollView {
            let content = VStack(spacing: spacing.extraLarge) {
                Spacer(minLength: 0)
                HKGlassCard {
                    VStack(alignment: .leading, spacing: spacing.large) { fields }
                }
                HKGlassGroup(spacing: spacing.large) {
                    VStack(spacing: spacing.large) { actions }
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, spacing.extraLarge)
            .padding(.vertical, spacing.extraLarge)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)

            if let availableHeight {
                content.frame(minHeight: max(0, availableHeight - 2 * spacing.extraLarge))
            } else {
                content
            }
        }
    }
}
