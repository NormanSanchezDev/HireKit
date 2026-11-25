import HKDesignSystem
import SwiftUI

/// The sign-up screen, pushed from sign in.
struct SignUpView: View {
    @State private var viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
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

    private func content(_ state: SignUpUIState) -> some View {
        AuthForm {
            HKLabel(model: state.titleLabel)
                .accessibilityAddTraits(.isHeader)
            HKField(model: state.firstNameField, text: $viewModel.firstName) {
                viewModel.nameEditingEnded(.firstName)
            }
            HKField(model: state.paternalLastNameField, text: $viewModel.paternalLastName) {
                viewModel.nameEditingEnded(.paternalLastName)
            }
            HKField(model: state.maternalLastNameField, text: $viewModel.maternalLastName) {
                viewModel.nameEditingEnded(.maternalLastName)
            }
            HKDatePicker(model: state.birthDateField, date: $viewModel.birthDate)
            HKPhoneField(model: state.phoneField, dialCode: $viewModel.dialCode, digits: $viewModel.phoneDigits)
            HKField(model: state.emailField, text: $viewModel.email)
            HKField(model: state.passwordField, text: $viewModel.password)
        } actions: {
            HKButton(model: state.signUpButton)
                .keyboardShortcut(.defaultAction)
        }
        .navigationTitle(state.navigationTitle)
        .alert(state.errorTitle, isPresented: $viewModel.isShowingError, presenting: state.errorMessage) { _ in
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
#Preview("Sign up") {
    NavigationStack {
        SignUpView(viewModel: HKPreviewViewModelFactory().makeSignUpViewModel(
            onAuthenticated: {},
            onConfirmationRequired: {}
        ))
    }
}
#endif
