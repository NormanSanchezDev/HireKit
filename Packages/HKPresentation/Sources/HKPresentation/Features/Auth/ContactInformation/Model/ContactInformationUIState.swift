import HKDesignSystem
import HKDomain
import SwiftUI

/// The display content and interaction state of the contact information
/// step of sign-up.
///
/// ``ContactInformationViewModel`` creates it in
/// ``ContactInformationViewModel/onAppear()`` and owns every change, so the
/// view only renders it. The password lives only here, in memory.
public struct ContactInformationUIState {
    /// The screen heading.
    public let titleLabel = HKLabelModel(text: "contact_information_title_txt", type: .title, tone: .accent)

    /// The supporting text below the heading.
    public let descriptionLabel = HKLabelModel(text: "contact_information_description_txt", type: .subheadline)

    /// The step indicator, "Paso 2 de 2".
    public let progress = HKProgressModel(progress: 1, type: .linear, label: "common_step_\(2)_of_\(2)")

    /// The title of the navigation bar.
    public let navigationTitle: LocalizedStringKey = "contact_information_navigation_title_txt"

    /// The title of the error alert.
    public let errorTitle: LocalizedStringKey = "common_error_title"

    /// The title of the error alert's retry action.
    public let retryTitle: LocalizedStringKey = "common_retry"

    /// The title of the action that closes an alert.
    public let dismissTitle: LocalizedStringKey = "common_ok"

    /// The title of the alert shown when the email must be confirmed.
    public let confirmationTitle: LocalizedStringKey = "sign_up_confirmation_title_txt"

    /// The email the person typed.
    public internal(set) var email: String

    /// The calling code of the phone number.
    public internal(set) var dialCode: DialCode

    /// The national phone number, digits only.
    public internal(set) var phoneDigits: String

    /// The password the person typed. It is never stored outside this state.
    public internal(set) var password = ""

    /// The validation message for the email, if any.
    public internal(set) var emailError: LocalizedStringKey?

    /// The validation message for the phone number, if any.
    public internal(set) var phoneError: LocalizedStringKey?

    /// The validation message for the password, if any.
    public internal(set) var passwordError: LocalizedStringKey?

    /// Whether an account request is in flight.
    public internal(set) var isLoading = false

    /// The safe message of a failed request, if any.
    public internal(set) var errorMessage: LocalizedStringKey?

    /// Whether the failed request can be retried, as after a network error.
    public internal(set) var canRetry = false

    /// The address that must be confirmed before signing in, if any.
    public internal(set) var pendingConfirmationEmail: String?

    let onCreateAccount: () -> Void
    let onBack: () -> Void
    let onRetry: () -> Void
    let onConfirmationAcknowledged: () -> Void

    init(
        email: String,
        dialCode: DialCode,
        phoneDigits: String,
        onCreateAccount: @escaping () -> Void,
        onBack: @escaping () -> Void,
        onRetry: @escaping () -> Void,
        onConfirmationAcknowledged: @escaping () -> Void
    ) {
        self.email = email
        self.dialCode = dialCode
        self.phoneDigits = phoneDigits
        self.onCreateAccount = onCreateAccount
        self.onBack = onBack
        self.onRetry = onRetry
        self.onConfirmationAcknowledged = onConfirmationAcknowledged
    }

    /// The message that asks the person to confirm ``pendingConfirmationEmail``.
    public var confirmationMessage: LocalizedStringKey? {
        pendingConfirmationEmail.map { "sign_up_confirmation_message_\($0)_txt" }
    }

    /// The email field.
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

    /// The password field. It starts hidden and offers a show and hide control.
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

    /// The button that creates the account. It shows progress while the
    /// request is in flight.
    public var createAccountButton: HKButtonModel {
        HKButtonModel(
            title: "contact_information_create_account_button_txt",
            isLoading: isLoading,
            action: onCreateAccount
        )
    }

    /// The button that returns to the personal information step.
    public var backButton: HKButtonModel {
        HKButtonModel(title: "common_back", variant: .outline, isEnabled: !isLoading, action: onBack)
    }
}
