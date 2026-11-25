import HKDesignSystem
import SwiftUI

/// The display content and interaction state of the sign-in screen.
///
/// ``SignInViewModel`` creates it in ``SignInViewModel/onAppear()`` and owns
/// every change, so the view only renders it.
public struct SignInUIState {
    /// The screen heading.
    public let titleLabel = HKLabelModel(text: "sign_in_title_txt", type: .title, tone: .accent)

    /// The supporting text below the heading.
    public let descriptionLabel = HKLabelModel(text: "sign_in_description_txt", type: .subheadline)

    /// The title of the navigation bar.
    public let navigationTitle: LocalizedStringKey = "sign_in_navigation_title_txt"

    /// The prompt and action that open the sign-up screen.
    public let accountPrompt = HKActionPromptModel(
        prompt: HKLabelModel(text: "sign_in_account_prompt_txt", type: .subheadline, tone: .secondary),
        actionTitle: "sign_in_create_account_button_txt"
    )

    /// The title of the error alert.
    public let errorTitle: LocalizedStringKey = "common_error_title"

    /// The email the user typed.
    public internal(set) var email = ""

    /// The password the user typed.
    public internal(set) var password = ""

    /// The validation message for the email, if any.
    public internal(set) var emailError: LocalizedStringKey?

    /// The validation message for the password, if any.
    public internal(set) var passwordError: LocalizedStringKey?

    /// Whether a sign-in request is in flight.
    public internal(set) var isLoading = false

    /// The message of a failed sign-in request, if any.
    public internal(set) var errorMessage: LocalizedStringKey?

    let onSignIn: () -> Void
    let onCreateAccount: () -> Void

    /// The email field, with its validation message.
    public var emailField: HKFieldModel {
        HKFieldModel(
            title: "sign_in_email_txt",
            placeholder: "sign_in_email_placeholder_txt",
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
            title: "sign_in_password_txt",
            icon: "lock",
            contentType: .password,
            isSecure: true,
            isRequired: true,
            errorMessage: passwordError,
            isEnabled: !isLoading
        )
    }

    /// The submit button, which shows progress while signing in.
    public var signInButton: HKButtonModel {
        HKButtonModel(title: "sign_in_submit_button_txt", isLoading: isLoading, action: onSignIn)
    }
}
