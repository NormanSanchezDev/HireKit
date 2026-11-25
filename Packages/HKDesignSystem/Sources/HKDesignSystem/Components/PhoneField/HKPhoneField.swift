import SwiftUI

/// A titled phone field on a Liquid Glass surface, with a calling code menu
/// and a number formatted as the person types.
///
/// The number shows as `(XX) XX XX XX XX` while the binding keeps only its
/// ten digits, so the calling code and the number can be stored apart:
///
/// ```swift
/// HKPhoneField(
///     model: .init(title: "sign_up_phone_txt", dialCodes: dialCodes, isRequired: true),
///     dialCode: $viewModel.dialCode,
///     digits: $viewModel.phoneDigits
/// )
/// ```
public struct HKPhoneField<DialCode: Hashable>: View {
    @Environment(\.hkTheme) private var theme
    @Environment(\.isEnabled) private var parentIsEnabled
    @Binding private var dialCode: DialCode
    @Binding private var digits: String
    @FocusState private var isFocused: Bool
    @State private var text = ""

    private let model: HKPhoneFieldModel<DialCode>

    /// Creates a phone field.
    ///
    /// - Parameters:
    ///   - model: The content and configuration of the field.
    ///   - dialCode: The selected calling code.
    ///   - digits: The national number, digits only.
    public init(model: HKPhoneFieldModel<DialCode>, dialCode: Binding<DialCode>, digits: Binding<String>) {
        self.model = model
        _dialCode = dialCode
        _digits = digits
    }

    private var isEnabled: Bool { model.isEnabled && parentIsEnabled }

    public var body: some View {
        HKFieldContainer(title: model.title, validation: model.validation, isEnabled: isEnabled, isFocused: isFocused) {
            HKDropdown(title: "common_dial_code", options: model.dialCodes, selection: $dialCode)
            Divider()
                .frame(maxHeight: theme.spacing.large)
            TextField(model.placeholder, text: $text)
                .textFieldStyle(.plain)
                .textContentType(.telephoneNumber)
                #if os(iOS)
                .keyboardType(.phonePad)
                #endif
                .monospacedDigit()
                .focused($isFocused)
                .accessibilityLabel(Text(fieldTitle: model.title, isRequired: model.isRequired))
                .accessibilityHint(model.validation.feedback(in: theme.colors)?.description ?? Text(verbatim: ""))
        }
        .disabled(!model.isEnabled)
        .onAppear(perform: showDigits)
        .onChange(of: text) { _, newText in applyMask(to: newText) }
        .onChange(of: digits) { _, newDigits in
            if HKPhoneFormat.digits(in: text) != newDigits { showDigits() }
        }
        .onChange(of: isEnabled) { _, enabled in
            if !enabled { isFocused = false }
        }
    }

    private func showDigits() {
        text = HKPhoneFormat.format(digits)
    }

    private func applyMask(to newText: String) {
        let newDigits = HKPhoneFormat.digits(in: newText)
        if digits != newDigits { digits = newDigits }
        let formatted = HKPhoneFormat.format(newDigits)
        if text != formatted { text = formatted }
    }
}

#Preview("Phone field states") {
    @Previewable @State var code = "+52"
    @Previewable @State var empty = ""
    @Previewable @State var filled = "5625068370"
    let codes = [
        HKDropdownOption(value: "+52", title: "🇲🇽 +52", accessibilityLabel: "common_dial_code_mexico"),
        HKDropdownOption(value: "+1", title: "🇺🇸 +1", accessibilityLabel: "common_dial_code_united_states"),
    ]
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            HKPhoneField(model: .init(title: "sign_up_phone_txt", dialCodes: codes, isRequired: true), dialCode: $code, digits: $empty)
            HKPhoneField(model: .init(title: "sign_up_phone_txt", dialCodes: codes), dialCode: $code, digits: $filled)
            HKPhoneField(model: .init(title: "sign_up_phone_txt", dialCodes: codes, errorMessage: "sign_up_phone_invalid_txt"), dialCode: $code, digits: $empty)
        }
        .padding()
    }
    .hkBackground()
}
