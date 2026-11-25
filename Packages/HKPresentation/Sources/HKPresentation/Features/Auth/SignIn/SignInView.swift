import HKDesignSystem
import SwiftUI

/// The sign-in screen, the root of the auth flow.
struct SignInView: View {
    @State private var viewModel: SignInViewModel

    init(viewModel: SignInViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            if let state = viewModel.uiState {
                content(state)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: viewModel.onAppear)
    }

    private func content(_ state: SignInUIState) -> some View {
        AuthForm(centersContent: true) {
            HKLabel(model: state.titleLabel)
                .accessibilityAddTraits(.isHeader)
            HKLabel(model: state.descriptionLabel)
            HKField(model: state.emailField, text: $viewModel.email)
            HKField(model: state.passwordField, text: $viewModel.password)
        } actions: {
            HKButton(model: state.signInButton)
                .keyboardShortcut(.defaultAction)
            HKActionPrompt(model: state.accountPrompt, action: state.onCreateAccount)
                .disabled(state.isLoading)
        }
        .navigationTitle(state.navigationTitle)
        .alert(state.errorTitle, isPresented: $viewModel.isShowingError, presenting: state.errorMessage) { _ in
        } message: { message in
            Text(message)
        }
    }
}

#if DEBUG
#Preview("Sign in") {
    NavigationStack {
        SignInView(viewModel: HKPreviewViewModelFactory().makeSignInViewModel(onSignUp: {}, onAuthenticated: {}))
    }
}
#endif
