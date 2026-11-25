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
            HKLabel("Inicia sesión", type: .title, tone: .accent)
                .accessibilityAddTraits(.isHeader)
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
                    contentType: .password,
                    isSecure: true,
                    isRequired: true,
                    errorMessage: viewModel.passwordError
                ),
                text: $viewModel.password
            )
        } actions: {
            HKButton(model: .init(title: "Entrar") { viewModel.signIn() })
                .keyboardShortcut(.defaultAction)
            HStack(spacing: theme.spacing.small) {
                HKLabel("¿No tienes cuenta?", type: .subheadline, tone: .secondary)
                Button("Crear cuenta") { viewModel.goToSignUp() }
                    .buttonStyle(.plain)
                    .foregroundStyle(theme.colors.primary)
                    .frame(minHeight: theme.spacing.minimumHitTarget)
            }
        }
        .navigationTitle("Acceso")
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
