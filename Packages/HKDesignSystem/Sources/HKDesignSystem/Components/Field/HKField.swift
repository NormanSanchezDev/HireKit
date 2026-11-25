import SwiftUI

/// A titled text field on a Liquid Glass surface, with validation feedback.
///
/// Describe the field with an ``HKFieldModel`` and bind its text:
///
/// ```swift
/// HKField(
///     model: .init(
///         title: "Contraseña",
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
/// when either its model or its environment disables it.
public struct HKField: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var parentIsEnabled
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible = false
    @State private var restoreEditingFocus = false

    private let model: HKFieldModel

    /// Creates a field.
    ///
    /// - Parameters:
    ///   - model: The content and configuration of the field.
    ///   - text: The text to display and edit.
    public init(model: HKFieldModel, text: Binding<String>) {
        self.model = model
        _text = text
    }

    private var isEnabled: Bool { model.isEnabled && parentIsEnabled }

    public var body: some View {
        let theme = themeManager.current(for: colorScheme)
        let shape = RoundedRectangle(cornerRadius: theme.radius.medium)
        let feedback = feedback(in: theme.colors)
        let focused = isEnabled && isFocused
        let outline = isEnabled ? feedback?.color ?? (focused ? theme.colors.primary : nil) : nil

        VStack(alignment: .leading, spacing: theme.spacing.medium) {
            HStack(spacing: theme.spacing.small) {
                Text(model.title)
                if model.isRequired { Text("*").foregroundStyle(theme.colors.error) }
            }
            .font(theme.typography.fieldLabel)
            .accessibilityHidden(true)

            HStack(spacing: theme.spacing.medium) {
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
                    .textInputAutocapitalization(.never)
                    #endif
                    .font(theme.typography.body)
                    .accessibilityLabel(model.isRequired ? Text("\(model.title), obligatorio") : Text(model.title))
                    .accessibilityHint(feedback?.description ?? Text(""))
                if model.isSecure {
                    revealButton(minimumSide: theme.spacing.minimumHitTarget)
                }
            }
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
        .disabled(!model.isEnabled)
        .onChange(of: isEnabled) { _, enabled in
            if !enabled {
                restoreEditingFocus = false
                isFocused = false
                isPasswordVisible = false
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
            isPasswordVisible ? "Ocultar contraseña" : "Mostrar contraseña",
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

    private func feedback(in colors: HKColors) -> (message: String, icon: String, color: Color, description: Text)? {
        switch model.validation {
        case .none: nil
        case .success(let text): (text, "checkmark.circle", colors.success, Text("Correcto: \(text)"))
        case .warning(let text): (text, "exclamationmark.triangle", colors.warning, Text("Advertencia: \(text)"))
        case .error(let text): (text, "exclamationmark.circle", colors.error, Text("Error: \(text)"))
        }
    }
}

#Preview("Field states") {
    @Previewable @State var email = ""
    @Previewable @State var password = ""
    @Previewable @State var enabled = true
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Enable editing", isOn: $enabled)
            HKField(model: .init(title: "Email", placeholder: "name@example.com", icon: "envelope", isRequired: true), text: $email)
                .disabled(!enabled)
            HKField(model: .init(title: "Password", icon: "lock", isSecure: true), text: $password)
            HKField(model: .init(title: "Username", isEnabled: false), text: .constant("hirekit"))
            HKField(model: .init(title: "Email", validation: .error("Enter a valid email address.")), text: $email)
            HKField(model: .init(title: "Password", isSecure: true, validation: .warning("Choose a longer password.")), text: $password)
            HKField(model: .init(title: "Email", validation: .success("Address verified.")), text: .constant("hello@example.com"))
        }
        .padding()
    }
    .hkBackdrop()
    .environment(HKThemeManager(defaults: nil))
}
