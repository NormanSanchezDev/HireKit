import HKDesignSystem
import SwiftUI

/// The shared layout of the auth screens: fields on a glass card, actions
/// below, with a capped width that reads well on iPad and Mac.
struct AuthForm<Fields: View, Actions: View>: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    private let fields: Fields
    private let actions: Actions

    init(@ViewBuilder fields: () -> Fields, @ViewBuilder actions: () -> Actions) {
        self.fields = fields()
        self.actions = actions()
    }

    var body: some View {
        let spacing = themeManager.current(for: colorScheme).spacing
        ScrollView {
            VStack(spacing: spacing.extraLarge) {
                HKGlassCard {
                    VStack(alignment: .leading, spacing: spacing.large) { fields }
                }
                HKGlassGroup(spacing: spacing.large) {
                    VStack(spacing: spacing.large) { actions }
                }
            }
            .padding(spacing.extraLarge)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .hkBackdrop()
    }
}
