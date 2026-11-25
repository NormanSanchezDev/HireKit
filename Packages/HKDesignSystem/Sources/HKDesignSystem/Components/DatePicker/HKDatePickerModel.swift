import SwiftUI

/// The content and configuration of an ``HKDatePicker``.
///
/// ```swift
/// HKDatePickerModel(
///     title: "sign_up_birth_date_txt",
///     placeholder: "common_date_placeholder",
///     range: earliest...latest,
///     isRequired: true,
///     errorMessage: uiState.birthDateError
/// )
/// ```
public struct HKDatePickerModel {
    /// The title shown above the field. VoiceOver reads it as the label.
    public let title: LocalizedStringKey

    /// The hint shown while no date is selected, such as `dd/mm/yyyy`.
    public let placeholder: LocalizedStringKey

    /// The dates the calendar offers. Typed dates are not limited, so the
    /// screen validates them.
    public let range: ClosedRange<Date>

    /// Whether the field is required during validation.
    public let isRequired: Bool

    /// Whether the person can change the date.
    public let isEnabled: Bool

    /// The feedback shown below the field.
    public let validation: HKFieldValidation

    /// Creates a date picker model.
    ///
    /// - Parameters:
    ///   - title: The title shown above the field.
    ///   - placeholder: The hint shown while no date is selected.
    ///   - range: The dates the person can pick.
    ///   - isRequired: Whether the field is required during validation.
    ///   - errorMessage: A shortcut for an ``HKFieldValidation/error(_:)``
    ///     validation. When it is not `nil`, it replaces `validation`.
    ///   - isEnabled: Whether the person can change the date.
    ///   - validation: The feedback shown below the field.
    public init(
        title: LocalizedStringKey,
        placeholder: LocalizedStringKey = "common_date_placeholder",
        range: ClosedRange<Date>,
        isRequired: Bool = false,
        errorMessage: LocalizedStringKey? = nil,
        isEnabled: Bool = true,
        validation: HKFieldValidation = .none
    ) {
        self.title = title
        self.placeholder = placeholder
        self.range = range
        self.isRequired = isRequired
        self.isEnabled = isEnabled
        self.validation = errorMessage.map(HKFieldValidation.error) ?? validation
    }

}
