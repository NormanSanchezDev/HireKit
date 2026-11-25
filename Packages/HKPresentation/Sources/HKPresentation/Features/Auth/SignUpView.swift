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
            HKLabel("Crea tu cuenta", type: .title, tone: .accent)
                .accessibilityAddTraits(.isHeader)
            HKField(
                model: .init(
                    title: "Nombre",
                    icon: "person",
                    contentType: .name,
                    isRequired: true,
                    errorMessage: viewModel.nameError
                ),
                text: $viewModel.name
            )
            HKField(
                model: .init(
                    title: "Correo",
                    placeholder: "nombre@ejemplo.com",
                    icon: "envelope",
                    contentType: .emailAddress,
                    isRequired: true,
                    errorMessage: viewModel.emailError
                ),
                text: $viewModel.email
            )
            HKField(
                model: .init(
                    title: "Contraseña",
                    icon: "lock",
                    contentType: .newPassword,
                    isSecure: true,
                    isRequired: true,
                    errorMessage: viewModel.passwordError
                ),
                text: $viewModel.password
            )
        } actions: {
            HKButton(model: .init(title: "Crear cuenta") { viewModel.signUp() })
                .keyboardShortcut(.defaultAction)
        }
        .navigationTitle("Registro")
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
