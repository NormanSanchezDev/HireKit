import SwiftUI

/// One choice of an ``HKDropdown``.
///
/// ```swift
/// HKDropdownOption(value: "+52", title: "🇲🇽 +52", accessibilityLabel: "common_dial_code_mexico")
/// ```
public struct HKDropdownOption<Value: Hashable>: Identifiable {
    /// The value the option selects.
    public let value: Value

    /// The text shown for the option, such as a flag and a calling code.
    public let title: String

    /// The name VoiceOver reads for the option.
    public let accessibilityLabel: LocalizedStringKey

    /// The identity of the option, which is its value.
    public var id: Value { value }

    /// Creates an option.
    ///
    /// - Parameters:
    ///   - value: The value the option selects.
    ///   - title: The text shown for the option.
    ///   - accessibilityLabel: The name VoiceOver reads for the option.
    public init(value: Value, title: String, accessibilityLabel: LocalizedStringKey) {
        self.value = value
        self.title = title
        self.accessibilityLabel = accessibilityLabel
    }
}
