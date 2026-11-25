import HKDesignSystem
import SwiftUI

/// The sign-in screen, the root of the auth flow.
struct SignInView: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel: SignInViewModel

    init(viewModel: SignInViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        let theme = themeManager.current(for: colorScheme)
        AuthForm {
            HKLabel("sign_in_title_txt", type: .title, tone: .accent)
                .accessibilityAddTraits(.isHeader)
            HKField(
                model: .init(
                    title: "sign_in_email_txt",
                    placeholder: "sign_in_email_placeholder_txt",
                    icon: "envelope",
                    contentType: .emailAddress,
                    isRequired: true,
                    errorMessage: viewModel.emailError
                ),
                text: $viewModel.email
            )
            HKField(
                model: .init(
                    title: "sign_in_password_txt",
                    icon: "lock",
                    contentType: .password,
                    isSecure: true,
                    isRequired: true,
                    errorMessage: viewModel.passwordError
                ),
                text: $viewModel.password
            )
        } actions: {
            HKButton(model: .init(title: "sign_in_submit_button_txt") { viewModel.signIn() })
                .keyboardShortcut(.defaultAction)
            HStack(spacing: theme.spacing.small) {
                HKLabel("sign_in_account_prompt_txt", type: .subheadline, tone: .secondary)
                Button("sign_in_create_account_button_txt") { viewModel.goToSignUp() }
                    .buttonStyle(.plain)
                    .foregroundStyle(theme.colors.primary)
                    .frame(minHeight: theme.spacing.minimumHitTarget)
            }
        }
        .navigationTitle("sign_in_navigation_title_txt")
    }
}

#if DEBUG
#Preview("Sign in") {
    NavigationStack {
        SignInView(viewModel: HKPreviewViewModelFactory().makeSignInViewModel(onSignUp: {}, onAuthenticated: {}))
    }
    .environment(HKThemeManager(defaults: nil))
}
#endif
