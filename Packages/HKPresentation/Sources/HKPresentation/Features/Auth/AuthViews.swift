import HKDesignSystem
import SwiftUI

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
            HKLabel(model: .init(text: "Inicia sesión", type: .title, tone: .accent))
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
            HKButton("Entrar") { viewModel.signIn() }
                .keyboardShortcut(.defaultAction)
            HStack(spacing: theme.spacing.small) {
                HKLabel(model: .init(text: "¿No tienes cuenta?", type: .subheadline, tone: .secondary))
                Button("Crear cuenta") { viewModel.goToSignUp() }
                    .buttonStyle(.plain)
                    .foregroundStyle(theme.colors.primary)
            }
        }
        .navigationTitle("Acceso")
    }
}

struct SignUpView: View {
    @State private var viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        AuthForm {
            HKLabel(model: .init(text: "Crea tu cuenta", type: .title, tone: .accent))
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
            HKButton("Crear cuenta") { viewModel.signUp() }
                .keyboardShortcut(.defaultAction)
        }
        .navigationTitle("Registro")
    }
}

/// Shared layout for auth screens: fields on a glass card, actions below,
/// capped width so it reads well on iPad and Mac.
private struct AuthForm<Fields: View, Actions: View>: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    private let fields: Fields
    private let actions: Actions

    init(@ViewBuilder fields: () -> Fields, @ViewBuilder actions: () -> Actions) {
        self.fields = fields()
        self.actions = actions()
    }

    var body: some View {
        let spacing = themeManager.current(for: colorScheme).spacing
        ScrollView {
            VStack(spacing: spacing.extraLarge) {
                HKGlassCard {
                    VStack(alignment: .leading, spacing: spacing.large) { fields }
                }
                VStack(spacing: spacing.large) { actions }
            }
            .padding(spacing.extraLarge)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .hkBackdrop()
    }
}

#if DEBUG
#Preview("Sign in") {
    NavigationStack {
        SignInView(viewModel: HKPreviewViewModelFactory().makeSignInViewModel(onSignUp: {}, onAuthenticated: {}))
    }
    .environment(HKThemeManager(defaults: nil))
}

#Preview("Sign up") {
    NavigationStack {
        SignUpView(viewModel: HKPreviewViewModelFactory().makeSignUpViewModel {})
    }
    .environment(HKThemeManager(defaults: nil))
}
#endif
