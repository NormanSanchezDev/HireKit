import HKDesignSystem
import HKDomain
import SwiftUI

/// The display content and interaction state of the sign-up screen.
///
/// ``SignUpViewModel`` creates it in ``SignUpViewModel/onAppear()`` and owns
/// every change, so the view only renders it.
public struct SignUpUIState {
    /// The screen heading.
    public let titleLabel = HKLabelModel(text: "sign_up_title_txt", type: .title, tone: .accent)

    /// The title of the navigation bar.
    public let navigationTitle: LocalizedStringKey = "sign_up_navigation_title_txt"

    /// The title of the error alert.
    public let errorTitle: LocalizedStringKey = "common_error_title"

    /// The title of the alert shown when the email must be confirmed.
    public let confirmationTitle: LocalizedStringKey = "sign_up_confirmation_title_txt"

    /// The title of the confirmation alert's action.
    public let dismissTitle: LocalizedStringKey = "common_ok"

    /// The dates of birth the picker offers, from the oldest to the youngest
    /// allowed age.
    public let birthDateRange: ClosedRange<Date>

    /// The given names the user typed.
    public internal(set) var firstName = ""

    /// The paternal surname the user typed.
    public internal(set) var paternalLastName = ""

    /// The maternal surname the user typed, empty when they have none.
    public internal(set) var maternalLastName = ""

    /// The date of birth the user picked, if any.
    public internal(set) var birthDate: Date?

    /// The calling code of the phone number.
    public internal(set) var dialCode = DialCode.mexico

    /// The national phone number, digits only.
    public internal(set) var phoneDigits = ""

    /// The email the user typed.
    public internal(set) var email = ""

    /// The password the user typed.
    public internal(set) var password = ""

    /// The validation message for the given names, if any.
    public internal(set) var firstNameError: LocalizedStringKey?

    /// The validation message for the paternal surname, if any.
    public internal(set) var paternalLastNameError: LocalizedStringKey?

    /// The validation message for the maternal surname, if any.
    public internal(set) var maternalLastNameError: LocalizedStringKey?

    /// The validation message for the date of birth, if any.
    public internal(set) var birthDateError: LocalizedStringKey?

    /// The validation message for the phone number, if any.
    public internal(set) var phoneError: LocalizedStringKey?

    /// The validation message for the email, if any.
    public internal(set) var emailError: LocalizedStringKey?

    /// The validation message for the password, if any.
    public internal(set) var passwordError: LocalizedStringKey?

    /// Whether a sign-up request is in flight.
    public internal(set) var isLoading = false

    /// The message of a failed sign-up request, if any.
    public internal(set) var errorMessage: LocalizedStringKey?

    /// The address that must be confirmed before signing in, if any.
    public internal(set) var pendingConfirmationEmail: String?

    let onSignUp: () -> Void
    let onConfirmationAcknowledged: () -> Void

    init(
        birthDateRange: ClosedRange<Date>,
        onSignUp: @escaping () -> Void,
        onConfirmationAcknowledged: @escaping () -> Void
    ) {
        self.birthDateRange = birthDateRange
        self.onSignUp = onSignUp
        self.onConfirmationAcknowledged = onConfirmationAcknowledged
    }

    /// The message that asks the user to confirm ``pendingConfirmationEmail``.
    public var confirmationMessage: LocalizedStringKey? {
        pendingConfirmationEmail.map { "sign_up_confirmation_message_\($0)_txt" }
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

    /// The date of birth field, limited to ``birthDateRange``.
    public var birthDateField: HKDatePickerModel {
        HKDatePickerModel(
            title: "sign_up_birth_date_txt",
            range: birthDateRange,
            isRequired: true,
            errorMessage: birthDateError,
            isEnabled: !isLoading
        )
    }

    /// The phone field, with Mexico and the United States as calling codes.
    public var phoneField: HKPhoneFieldModel<DialCode> {
        HKPhoneFieldModel(
            title: "sign_up_phone_txt",
            dialCodes: DialCode.dropdownOptions,
            isRequired: true,
            errorMessage: phoneError,
            isEnabled: !isLoading
        )
    }

    /// The email field, with its validation message.
    public var emailField: HKFieldModel {
        HKFieldModel(
            title: "sign_up_email_txt",
            placeholder: "sign_up_email_placeholder_txt",
            icon: "envelope",
            contentType: .emailAddress,
            isRequired: true,
            errorMessage: emailError,
            isEnabled: !isLoading
        )
    }

    /// The password field, with its validation message.
    public var passwordField: HKFieldModel {
        HKFieldModel(
            title: "sign_up_password_txt",
            icon: "lock",
            contentType: .newPassword,
            isSecure: true,
            isRequired: true,
            errorMessage: passwordError,
            isEnabled: !isLoading
        )
    }

    /// The submit button, which shows progress while creating the account.
    public var signUpButton: HKButtonModel {
        HKButtonModel(title: "sign_up_submit_button_txt", isLoading: isLoading, action: onSignUp)
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
            errorMessage: errorMessage,
            isEnabled: !isLoading
        )
    }
}
