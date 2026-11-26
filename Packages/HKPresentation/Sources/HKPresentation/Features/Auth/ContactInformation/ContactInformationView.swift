import HKDesignSystem
import SwiftUI

/// The second sign-up step: email, phone and password. It creates the account.
struct ContactInformationView: View {
    @State private var viewModel: ContactInformationViewModel

    init(viewModel: ContactInformationViewModel) {
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

    private func content(_ state: ContactInformationUIState) -> some View {
        AuthForm {
            HKProgress(model: state.progress)
            HKLabel(model: state.titleLabel)
                .accessibilityAddTraits(.isHeader)
            HKLabel(model: state.descriptionLabel)
            HKField(model: state.emailField, text: $viewModel.email)
            HKPhoneField(model: state.phoneField, dialCode: $viewModel.dialCode, digits: $viewModel.phoneDigits)
            HKField(model: state.passwordField, text: $viewModel.password)
        } actions: {
            HKButton(model: state.createAccountButton)
                .keyboardShortcut(.defaultAction)
            HKButton(model: state.backButton)
        }
        .navigationTitle(state.navigationTitle)
        .navigationBarBackButtonHidden(state.isLoading)
        .alert(state.errorTitle, isPresented: $viewModel.isShowingError, presenting: state.errorMessage) { _ in
            if state.canRetry {
                Button(state.retryTitle, action: state.onRetry)
            }
            Button(state.dismissTitle, role: .cancel) {}
        } message: { message in
            Text(message)
        }
        .alert(
            state.confirmationTitle,
            isPresented: $viewModel.isShowingConfirmation,
            presenting: state.confirmationMessage
        ) { _ in
            Button(state.dismissTitle, action: state.onConfirmationAcknowledged)
        } message: { message in
            Text(message)
        }
    }
}

#if DEBUG
#Preview("Contact information") {
    NavigationStack {
        ContactInformationView(viewModel: HKPreviewViewModelFactory().makeContactInformationViewModel(
            draft: SignUpDraft(),
            onBack: {},
            onAuthenticated: {},
            onConfirmationRequired: {}
        ))
    }
}
#endif
