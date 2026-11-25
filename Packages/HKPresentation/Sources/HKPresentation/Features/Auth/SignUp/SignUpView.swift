import HKDesignSystem
import SwiftUI

/// The sign-up screen, pushed from sign in.
struct SignUpView: View {
    @State private var viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        AuthForm {
            HKLabel("sign_up_title_txt", type: .title, tone: .accent)
                .accessibilityAddTraits(.isHeader)
            HKField(
                model: .init(
                    title: "sign_up_name_txt",
                    icon: "person",
                    contentType: .name,
                    isRequired: true,
                    errorMessage: viewModel.nameError
                ),
                text: $viewModel.name
            )
            HKField(
                model: .init(
                    title: "sign_up_email_txt",
                    placeholder: "sign_up_email_placeholder_txt",
                    icon: "envelope",
                    contentType: .emailAddress,
                    isRequired: true,
                    errorMessage: viewModel.emailError
                ),
                text: $viewModel.email
            )
            HKField(
                model: .init(
                    title: "sign_up_password_txt",
                    icon: "lock",
                    contentType: .newPassword,
                    isSecure: true,
                    isRequired: true,
                    errorMessage: viewModel.passwordError
                ),
                text: $viewModel.password
            )
        } actions: {
            HKButton(model: .init(title: "sign_up_submit_button_txt") { viewModel.signUp() })
                .padding(.horizontal, 24)
                .keyboardShortcut(.defaultAction)
        }
        .navigationTitle("sign_up_navigation_title_txt")
    }
}

#if DEBUG
#Preview("Sign up") {
    NavigationStack {
        SignUpView(viewModel: HKPreviewViewModelFactory().makeSignUpViewModel {})
    }
    .environment(HKThemeManager(defaults: nil))
}
#endif
