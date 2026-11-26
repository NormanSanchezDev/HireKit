import HKDesignSystem
import HKDomain
import SwiftUI

/// The display content and interaction state of the personal information
/// step of sign-up.
///
/// ``PersonalInformationViewModel`` creates it in
/// ``PersonalInformationViewModel/onAppear()`` and owns every change, so the
/// view only renders it.
public struct PersonalInformationUIState {
    /// The screen heading.
    public let titleLabel = HKLabelModel(text: "personal_information_title_txt", type: .title, tone: .accent)

    /// The supporting text below the heading.
    public let descriptionLabel = HKLabelModel(text: "personal_information_description_txt", type: .subheadline)

    /// The step indicator, "Paso 1 de 2".
    public let progress = HKProgressModel(progress: 0.5, type: .linear, label: "common_step_\(1)_of_\(2)")

    /// The title of the navigation bar.
    public let navigationTitle: LocalizedStringKey = "personal_information_navigation_title_txt"

    /// The dates of birth the calendar offers, from the oldest to the
    /// youngest allowed age.
    public let birthDateRange: ClosedRange<Date>

    /// The names and date of birth the person typed.
    public internal(set) var personal: PersonalInformation

    /// The validation message for the given names, if any.
    public internal(set) var firstNameError: LocalizedStringKey?

    /// The validation message for the paternal surname, if any.
    public internal(set) var paternalLastNameError: LocalizedStringKey?

    /// The validation message for the maternal surname, if any.
    public internal(set) var maternalLastNameError: LocalizedStringKey?

    /// The validation message for the date of birth, if any.
    public internal(set) var birthDateError: LocalizedStringKey?

    /// Whether every value is valid, so the person can continue.
    public internal(set) var canContinue = false

    let onContinue: () -> Void
    let onBack: () -> Void

    init(
        personal: PersonalInformation,
        birthDateRange: ClosedRange<Date>,
        onContinue: @escaping () -> Void,
        onBack: @escaping () -> Void
    ) {
        self.personal = personal
        self.birthDateRange = birthDateRange
        self.onContinue = onContinue
        self.onBack = onBack
    }

    /// The given names field.
    public var firstNameField: HKFieldModel {
        nameField(
            title: "sign_up_first_name_txt",
            placeholder: "sign_up_first_name_placeholder_txt",
            icon: "person",
            contentType: .givenName,
            isRequired: true,
            errorMessage: firstNameError
        )
    }

    /// The paternal surname field.
    public var paternalLastNameField: HKFieldModel {
        nameField(
            title: "sign_up_paternal_last_name_txt",
            placeholder: "sign_up_paternal_last_name_placeholder_txt",
            icon: "person.text.rectangle",
            contentType: .familyName,
            isRequired: true,
            errorMessage: paternalLastNameError
        )
    }

    /// The optional maternal surname field.
    public var maternalLastNameField: HKFieldModel {
        nameField(
            title: "sign_up_maternal_last_name_txt",
            placeholder: "sign_up_maternal_last_name_placeholder_txt",
            icon: "person.text.rectangle",
            contentType: nil,
            isRequired: false,
            errorMessage: maternalLastNameError
        )
    }

    /// The date of birth field. The calendar is limited to ``birthDateRange``.
    public var birthDateField: HKDatePickerModel {
        HKDatePickerModel(
            title: "sign_up_birth_date_txt",
            range: birthDateRange,
            isRequired: true,
            errorMessage: birthDateError
        )
    }

    /// The button that opens the contact step. It is disabled while any
    /// value is invalid.
    public var continueButton: HKButtonModel {
        HKButtonModel(title: "common_continue", isEnabled: canContinue, action: onContinue)
    }

    /// The button that returns to the sign-up introduction.
    public var backButton: HKButtonModel {
        HKButtonModel(title: "common_back", variant: .outline, action: onBack)
    }

    private func nameField(
        title: LocalizedStringKey,
        placeholder: LocalizedStringKey,
        icon: String,
        contentType: HKFieldContentType?,
        isRequired: Bool,
        errorMessage: LocalizedStringKey?
    ) -> HKFieldModel {
        HKFieldModel(
            title: title,
            placeholder: placeholder,
            icon: icon,
            contentType: contentType,
            capitalization: .words,
            isRequired: isRequired,
            errorMessage: errorMessage
        )
    }
}
