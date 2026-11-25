import SwiftUI

/// The shared frame of the design system's input controls: a title, a Liquid
/// Glass surface with a focus or validation outline, and feedback below.
///
/// ``HKField``, ``HKDatePicker`` and ``HKPhoneField`` place their input in it,
/// so every field looks and reads the same way.
struct HKFieldContainer<Input: View>: View {
    @Environment(\.hkTheme) private var theme

    private let title: LocalizedStringKey
    private let validation: HKFieldValidation
    private let isEnabled: Bool
    private let isFocused: Bool
    private let input: Input

    init(
        title: LocalizedStringKey,
        validation: HKFieldValidation,
        isEnabled: Bool,
        isFocused: Bool,
        @ViewBuilder input: () -> Input
    ) {
        self.title = title
        self.validation = validation
        self.isEnabled = isEnabled
        self.isFocused = isFocused
        self.input = input()
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: theme.radius.medium)
        let feedback = validation.feedback(in: theme.colors)
        let focused = isEnabled && isFocused
        let outline = isEnabled ? feedback?.color ?? (focused ? theme.colors.primary : nil) : nil

        VStack(alignment: .leading, spacing: theme.spacing.medium) {
            Text(title)
                .font(theme.typography.fieldLabel)
                .accessibilityHidden(true)

            HStack(spacing: theme.spacing.medium) {
                input
            }
            .font(theme.typography.body)
            .padding(.horizontal, theme.spacing.large)
            .padding(.vertical, theme.spacing.small)
            .frame(minHeight: theme.spacing.minimumHitTarget)
            .hkGlass(isInteractive: isEnabled, in: shape)
            .overlay {
                if let outline {
                    shape.strokeBorder(outline, lineWidth: focused ? 2 : 1)
                        .allowsHitTesting(false)
                }
            }

            if let feedback {
                Label { Text(feedback.message) } icon: { Image(systemName: feedback.icon) }
                    .font(theme.typography.caption)
                    .foregroundStyle(isEnabled ? feedback.color : theme.colors.textSecondary)
                    .accessibilityLabel(feedback.description)
            }
        }
        .foregroundStyle(isEnabled ? theme.colors.textPrimary : theme.colors.textSecondary)
        .tint(theme.colors.primary)
    }
}
