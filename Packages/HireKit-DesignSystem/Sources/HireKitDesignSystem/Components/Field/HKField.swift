//
//  HKField.swift
//  HireKit-DesignSystem
//
//  Created by Norman Sánchez on 24/11/26.
//

import SwiftUI

public struct HKField: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var parentIsEnabled
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible = false
    @State private var restoreEditingFocus = false

    private let model: HKFieldModel

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
        let border = isEnabled ? feedback?.color ?? (focused ? theme.colors.primary : theme.colors.border) : theme.colors.border

        VStack(alignment: .leading, spacing: theme.spacing.medium) {
            HStack(spacing: theme.spacing.small) {
                Text(model.title)
                if model.isRequired { Text("*").foregroundStyle(theme.colors.error) }
            }
            .font(theme.typography.subheadline.weight(.medium))
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
                    .accessibilityLabel(model.isRequired ? Text("\(model.title), required") : Text(model.title))
                    .accessibilityHint(feedback?.description ?? Text(""))
                if model.isSecure {
                    Button {
                        restoreEditingFocus = isFocused
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .frame(minWidth: theme.spacing.minimumHitTarget, minHeight: theme.spacing.minimumHitTarget)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isPasswordVisible ? Text("Hide password") : Text("Show password"))
                }
            }
            .padding(.horizontal, theme.spacing.large)
            .padding(.vertical, theme.spacing.small)
            .frame(minHeight: theme.spacing.minimumHitTarget)
            .background(theme.colors.surface, in: shape)
            .overlay {
                shape.strokeBorder(border, lineWidth: focused ? 2 : 1)
                    .allowsHitTesting(false)
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

    private func restoreFocusIfNeeded() {
        if restoreEditingFocus {
            restoreEditingFocus = false
            isFocused = isEnabled
        }
    }

    private func feedback(in colors: HKColors) -> (message: String, icon: String, color: Color, description: Text)? {
        switch model.validation {
        case .none: nil
        case .success(let text): (text, "checkmark.circle", colors.success, Text("Success: \(text)"))
        case .warning(let text): (text, "exclamationmark.triangle", colors.warning, Text("Warning: \(text)"))
        case .error(let text): (text, "exclamationmark.circle", colors.error, Text("Error: \(text)"))
        }
    }
}

#Preview("Field states") {
    @Previewable @State var email = ""
    @Previewable @State var password = ""
    @Previewable @State var enabled = true
    ScrollView {
        VStack(alignment: .leading) {
            Toggle("Enable editing", isOn: $enabled)
            HKField(model: .init(title: "Email", placeholder: "name@example.com", isRequired: true), text: $email)
                .disabled(!enabled)
            HKField(model: .init(title: "Password", isSecure: true), text: $password)
            HKField(model: .init(title: "Username", isEnabled: false), text: .constant("hirekit"))
            HKField(model: .init(title: "Email", validation: .error("Enter a valid email address.")), text: $email)
            HKField(model: .init(title: "Password", isSecure: true, validation: .warning("Choose a longer password.")), text: $password)
            HKField(model: .init(title: "Email", validation: .success("Address verified.")), text: .constant("hello@example.com"))
        }
        .padding()
    }
    .environment(HKThemeManager(defaults: nil))
}
