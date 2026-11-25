import SwiftUI

/// A compact menu that picks one value from a short list of options.
///
/// The dropdown has no surface of its own, so it sits inside a field such as
/// ``HKPhoneField`` or on any Liquid Glass surface:
///
/// ```swift
/// HKDropdown(
///     title: "common_dial_code",
///     options: [
///         HKDropdownOption(value: "+52", title: "🇲🇽 +52", accessibilityLabel: "common_dial_code_mexico"),
///         HKDropdownOption(value: "+1", title: "🇺🇸 +1", accessibilityLabel: "common_dial_code_united_states"),
///     ],
///     selection: $dialCode
/// )
/// ```
public struct HKDropdown<Value: Hashable>: View {
    @Environment(\.hkTheme) private var theme
    @Binding private var selection: Value

    private let title: LocalizedStringKey
    private let options: [HKDropdownOption<Value>]

    /// Creates a dropdown.
    ///
    /// - Parameters:
    ///   - title: The name VoiceOver reads for the dropdown.
    ///   - options: The choices, in display order.
    ///   - selection: The selected value.
    public init(title: LocalizedStringKey, options: [HKDropdownOption<Value>], selection: Binding<Value>) {
        self.title = title
        self.options = options
        _selection = selection
    }

    private var selectedOption: HKDropdownOption<Value>? {
        options.first { $0.value == selection }
    }

    public var body: some View {
        Menu {
            Picker(title, selection: $selection) {
                ForEach(options) { option in
                    Text(verbatim: option.title)
                        .accessibilityLabel(option.accessibilityLabel)
                        .tag(option.value)
                }
            }
            .pickerStyle(.inline)
        } label: {
            HStack(spacing: theme.spacing.small) {
                Text(verbatim: selectedOption?.title ?? "")
                    .monospacedDigit()
                Image(systemName: "chevron.up.chevron.down")
                    .imageScale(.small)
                    .foregroundStyle(theme.colors.textSecondary)
            }
            .frame(minWidth: theme.spacing.minimumHitTarget, minHeight: theme.spacing.minimumHitTarget)
            .contentShape(.rect)
        }
        .menuStyle(.button)
        .buttonStyle(.plain)
        .fixedSize()
        .accessibilityLabel(Text(title))
        .accessibilityValue(selectedOption.map { Text($0.accessibilityLabel) } ?? Text(verbatim: ""))
    }
}

#Preview("Dropdown") {
    @Previewable @State var code = "+52"
    HKDropdown(
        title: "common_dial_code",
        options: [
            HKDropdownOption(value: "+52", title: "🇲🇽 +52", accessibilityLabel: "common_dial_code_mexico"),
            HKDropdownOption(value: "+1", title: "🇺🇸 +1", accessibilityLabel: "common_dial_code_united_states"),
        ],
        selection: $code
    )
    .padding()
    .hkGlass(in: .capsule)
    .padding()
    .hkBackground()
}
