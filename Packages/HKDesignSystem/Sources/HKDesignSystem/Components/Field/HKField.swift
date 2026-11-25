import SwiftUI

/// A titled text field on a Liquid Glass surface, with validation feedback.
///
/// Describe the field with an ``HKFieldModel`` and bind its text:
///
/// ```swift
/// HKField(
///     model: .init(
///         title: "common_password",
///         icon: "lock",
///         contentType: .password,
///         isSecure: true,
///         errorMessage: viewModel.passwordError
///     ),
///     text: $viewModel.password
/// )
/// ```
///
/// The field outlines itself in the brand color while focused and in the
/// feedback color when it has ``HKFieldValidation``. Secure fields include a
/// button to reveal the text that keeps the keyboard up. The field is disabled
/// when either its model or its environment disables it. Pass
/// `onEditingEnded` to clean the text when the field loses focus.
public struct HKField: View {
    @Environment(\.hkTheme) private var theme
    @Environment(\.isEnabled) private var parentIsEnabled
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible = false
    @State private var restoreEditingFocus = false

    private let model: HKFieldModel
    private let onEditingEnded: (() -> Void)?

    /// Creates a field.
    ///
    /// - Parameters:
    ///   - model: The content and configuration of the field.
    ///   - text: The text to display and edit.
    ///   - onEditingEnded: An action to run when the field loses focus.
    public init(model: HKFieldModel, text: Binding<String>, onEditingEnded: (() -> Void)? = nil) {
        self.model = model
        _text = text
        self.onEditingEnded = onEditingEnded
    }

    private var isEnabled: Bool { model.isEnabled && parentIsEnabled }

    public var body: some View {
        HKFieldContainer(title: model.title, validation: model.validation, isEnabled: isEnabled, isFocused: isFocused) {
            if let icon = model.icon {
                Image(systemName: icon)
                    .foregroundStyle(theme.colors.textSecondary)
                    .accessibilityHidden(true)
            }
            input
                .textFieldStyle(.plain)
                .textContentType(model.contentType)
                #if os(iOS)
                .keyboardType(model.keyboardType)
                .textInputAutocapitalization(model.capitalization.textInputAutocapitalization)
                #endif
                .autocorrectionDisabled(model.capitalization == .never)
                .accessibilityLabel(Text(fieldTitle: model.title, isRequired: model.isRequired))
                .accessibilityHint(model.validation.feedback(in: theme.colors)?.description ?? Text(verbatim: ""))
            if model.isSecure {
                revealButton(minimumSide: theme.spacing.minimumHitTarget)
            }
        }
        .disabled(!model.isEnabled)
        .onChange(of: isEnabled) { _, enabled in
            if !enabled {
                restoreEditingFocus = false
                isFocused = false
                isPasswordVisible = false
            }
        }
        .onChange(of: isFocused) { _, focused in
            if !focused && !restoreEditingFocus {
                onEditingEnded?()
            }
        }
    }

    private var input: some View {
        Group {
            if model.isSecure && !isPasswordVisible {
                SecureField(model.placeholder, text: $text)
                    .focused($isFocused)
                    .onAppear(perform: restoreFocusIfNeeded)
            } else {
                TextField(model.placeholder, text: $text)
                    .focused($isFocused)
                    .onAppear(perform: restoreFocusIfNeeded)
            }
        }
    }

    private func revealButton(minimumSide: CGFloat) -> some View {
        Button(
            isPasswordVisible ? LocalizedStringKey("common_hide_password") : "common_show_password",
            systemImage: isPasswordVisible ? "eye.slash" : "eye"
        ) {
            restoreEditingFocus = isFocused
            isPasswordVisible.toggle()
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
        .frame(minWidth: minimumSide, minHeight: minimumSide)
        .contentShape(.rect)
    }

    private func restoreFocusIfNeeded() {
        if restoreEditingFocus {
            restoreEditingFocus = false
            isFocused = isEnabled
        }
    }
}

#Preview("Field states") {
    @Previewable @State var name = ""
    @Previewable @State var email = ""
    @Previewable @State var password = ""
    @Previewable @State var enabled = true
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("common_enable_editing", isOn: $enabled)
            HKField(model: .init(title: "common_email", placeholder: "common_email_placeholder", icon: "envelope", isRequired: true), text: $email)
                .disabled(!enabled)
            HKField(model: .init(title: "sign_up_first_name_txt", capitalization: .words), text: $name) {
                name = name.trimmingCharacters(in: .whitespaces)
            }
            HKField(model: .init(title: "common_password", icon: "lock", isSecure: true), text: $password)
            HKField(model: .init(title: "common_username", isEnabled: false), text: .constant("hirekit"))
            HKField(model: .init(title: "common_email", validation: .error("auth_email_invalid_txt")), text: $email)
            HKField(model: .init(title: "common_password", isSecure: true, validation: .warning("common_password_length_warning")), text: $password)
            HKField(model: .init(title: "common_email", validation: .success("common_address_verified")), text: .constant("hello@example.com"))
        }
        .padding()
    }
    .hkBackground()
}
