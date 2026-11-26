import HKDesignSystem
import SwiftUI

/// The first sign-up step: names and date of birth.
struct PersonalInformationView: View {
    @State private var viewModel: PersonalInformationViewModel

    init(viewModel: PersonalInformationViewModel) {
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

    private func content(_ state: PersonalInformationUIState) -> some View {
        AuthForm {
            HKProgress(model: state.progress)
            HKLabel(model: state.titleLabel)
                .accessibilityAddTraits(.isHeader)
            HKLabel(model: state.descriptionLabel)
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
        } actions: {
            HKButton(model: state.continueButton)
                .keyboardShortcut(.defaultAction)
            HKButton(model: state.backButton)
        }
        .navigationTitle(state.navigationTitle)
    }
}

#if DEBUG
#Preview("Personal information") {
    NavigationStack {
        PersonalInformationView(viewModel: HKPreviewViewModelFactory().makePersonalInformationViewModel(
            draft: SignUpDraft(),
            onContinue: {},
            onBack: {}
        ))
    }
}
#endif
