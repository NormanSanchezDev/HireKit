import HKDesignSystem
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

    /// The name the user typed.
    public internal(set) var name = ""

    /// The email the user typed.
    public internal(set) var email = ""

    /// The password the user typed.
    public internal(set) var password = ""

    /// The validation message for the name, if any.
    public internal(set) var nameError: LocalizedStringKey?

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

    /// The message that asks the user to confirm ``pendingConfirmationEmail``.
    public var confirmationMessage: LocalizedStringKey? {
        pendingConfirmationEmail.map { "sign_up_confirmation_message_\($0)_txt" }
    }

    /// The name field, with its validation message.
    public var nameField: HKFieldModel {
        HKFieldModel(
            title: "sign_up_name_txt",
            icon: "person",
            contentType: .name,
            isRequired: true,
            errorMessage: nameError,
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
}
