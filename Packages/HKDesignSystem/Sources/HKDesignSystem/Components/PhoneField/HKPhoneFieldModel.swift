import SwiftUI

/// The content and configuration of an ``HKPhoneField``.
///
/// ```swift
/// HKPhoneFieldModel(
///     title: "sign_up_phone_txt",
///     dialCodes: [
///         HKDropdownOption(value: "+52", title: "🇲🇽 +52", accessibilityLabel: "common_dial_code_mexico"),
///         HKDropdownOption(value: "+1", title: "🇺🇸 +1", accessibilityLabel: "common_dial_code_united_states"),
///     ],
///     isRequired: true,
///     errorMessage: uiState.phoneError
/// )
/// ```
public struct HKPhoneFieldModel<DialCode: Hashable> {
    /// The title shown above the field. VoiceOver reads it as the label.
    public let title: LocalizedStringKey

    /// The hint shown inside the number while it is empty.
    public let placeholder: LocalizedStringKey

    /// The calling codes the person can choose, in display order.
    public let dialCodes: [HKDropdownOption<DialCode>]

    /// Whether the field is required during validation.
    public let isRequired: Bool

    /// Whether the person can edit the field.
    public let isEnabled: Bool

    /// The feedback shown below the field.
    public let validation: HKFieldValidation

    /// Creates a phone field model.
    ///
    /// - Parameters:
    ///   - title: The title shown above the field.
    ///   - placeholder: The hint shown inside the empty number.
    ///   - dialCodes: The calling codes the person can choose.
    ///   - isRequired: Whether the field is required during validation.
    ///   - errorMessage: A shortcut for an ``HKFieldValidation/error(_:)``
    ///     validation. When it is not `nil`, it replaces `validation`.
    ///   - isEnabled: Whether the person can edit the field.
    ///   - validation: The feedback shown below the field.
    public init(
        title: LocalizedStringKey,
        placeholder: LocalizedStringKey = "common_phone_placeholder",
        dialCodes: [HKDropdownOption<DialCode>],
        isRequired: Bool = false,
        errorMessage: LocalizedStringKey? = nil,
        isEnabled: Bool = true,
        validation: HKFieldValidation = .none
    ) {
        self.title = title
        self.placeholder = placeholder
        self.dialCodes = dialCodes
        self.isRequired = isRequired
        self.isEnabled = isEnabled
        self.validation = errorMessage.map(HKFieldValidation.error) ?? validation
    }
}
