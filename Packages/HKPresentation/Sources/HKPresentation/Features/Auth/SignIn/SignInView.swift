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
        Group {
            if let state = viewModel.uiState {
                screen(state)
            }
        }
        .onAppear(perform: viewModel.onAppear)
    }

    private func screen(_ state: SignInUIState) -> some View {
        let theme = themeManager.current(for: colorScheme)
        return AuthForm {
            HKLabel(model: state.titleLabel)
                .accessibilityAddTraits(.isHeader)
            HKLabel(model: state.descriptionLabel)
            HKField(model: state.emailField, text: Binding(
                get: { state.email }, set: { viewModel.email = $0 }
            ))
            HKField(model: state.passwordField, text: Binding(
                get: { state.password }, set: { viewModel.password = $0 }
            ))
        } actions: {
            HKButton(model: state.signInButton)
                .keyboardShortcut(.defaultAction)
            HStack(spacing: theme.spacing.small) {
                HKLabel(model: state.accountPrompt)
                Button(state.createAccountTitle, action: state.onCreateAccount)
                    .buttonStyle(.plain)
                    .foregroundStyle(theme.colors.primary)
                    .frame(minHeight: theme.spacing.minimumHitTarget)
            }
        }
        .navigationTitle(state.navigationTitle)
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
