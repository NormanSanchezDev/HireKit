import HKDesignSystem
import SwiftUI

/// The display content and interaction state of the sign-in screen.
public struct SignInUIState {
    public let titleLabel = HKLabelModel(text: "sign_in_title_txt", type: .title, tone: .accent)
    public let descriptionLabel = HKLabelModel(text: "sign_in_description_txt", type: .subheadline)
    public let navigationTitle: LocalizedStringKey = "sign_in_navigation_title_txt"
    public var emailField: HKFieldModel {
        HKFieldModel(title: "sign_in_email_txt", placeholder: "sign_in_email_placeholder_txt", icon: "envelope", contentType: .emailAddress, isRequired: true, errorMessage: emailError)
    }
    public var passwordField: HKFieldModel {
        HKFieldModel(title: "sign_in_password_txt", icon: "lock", contentType: .password, isSecure: true, isRequired: true, errorMessage: passwordError)
    }
    public let signInTitle: LocalizedStringKey = "sign_in_submit_button_txt"
    public let accountPrompt = HKActionPromptModel(
        prompt: HKLabelModel(text: "sign_in_account_prompt_txt", type: .subheadline, tone: .secondary),
        actionTitle: "sign_in_create_account_button_txt"
    )

    public internal(set) var email = ""
    public internal(set) var password = ""
    public internal(set) var emailError: LocalizedStringKey?
    public internal(set) var passwordError: LocalizedStringKey?

    var onSignIn: () -> Void
    var onCreateAccount: () -> Void

    public var signInButton: HKButtonModel {
        HKButtonModel(title: signInTitle, action: onSignIn)
    }

    public init(onSignIn: @escaping () -> Void, onCreateAccount: @escaping () -> Void) {
        self.onSignIn = onSignIn
        self.onCreateAccount = onCreateAccount
    }
}
