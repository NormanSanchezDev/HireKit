import Foundation
import HKDesignSystem
import HKDomain
import HKPresentation
import SwiftUI
import Testing

@MainActor
struct PersonalInformationViewModelTests {
    private func makeViewModel(
        draft: SignUpDraft = SignUpDraft(),
        onContinue: @escaping @MainActor () -> Void = {},
        onBack: @escaping @MainActor () -> Void = {}
    ) -> PersonalInformationViewModel {
        let viewModel = PersonalInformationViewModel(
            draft: draft,
            currentDate: { SignUpFixtures.today },
            onContinue: onContinue,
            onBack: onBack
        )
        viewModel.onAppear()
        return viewModel
    }

    private func fill(_ viewModel: PersonalInformationViewModel) {
        viewModel.firstName = "Ana"
        viewModel.paternalLastName = "López"
        viewModel.birthDate = SignUpFixtures.adultBirthDate
    }

    @Test func firstAppearancePreparesTheStep() throws {
        let viewModel = makeViewModel()
        let state = try #require(viewModel.uiState)
        #expect(state.titleLabel.text == "personal_information_title_txt")
        #expect(state.progress.progress == 0.5)
        #expect(state.progress.label != nil)
        #expect(state.firstNameField.capitalization == .words)
        #expect(!state.maternalLastNameField.isRequired)
        #expect(state.birthDateField.range.upperBound < SignUpFixtures.today)
        #expect(!state.continueButton.isEnabled)
        #expect(state.backButton.title == "common_back")
    }

    @Test func continueIsEnabledOnlyWithValidValues() {
        let viewModel = makeViewModel()
        fill(viewModel)
        #expect(viewModel.uiState?.continueButton.isEnabled == true)
        viewModel.firstName = ""
        #expect(viewModel.uiState?.continueButton.isEnabled == false)
    }

    @Test func invalidValuesBlockNavigationAndShowErrors() throws {
        var continued = false
        let viewModel = makeViewModel(onContinue: { continued = true })
        viewModel.continueToContact()
        #expect(!continued)
        let state = try #require(viewModel.uiState)
        #expect(state.firstNameError == "sign_up_name_required_txt")
        #expect(state.paternalLastNameError == "sign_up_name_required_txt")
        #expect(state.maternalLastNameError == nil)
        #expect(state.birthDateError == "sign_up_birth_date_invalid_txt")
    }

    @Test func futureBirthDateShowsTheInvalidDateError() {
        let viewModel = makeViewModel()
        viewModel.birthDate = SignUpFixtures.today.addingTimeInterval(86_400 * 5)
        #expect(viewModel.uiState?.birthDateError == "sign_up_birth_date_invalid_txt")
        viewModel.birthDate = SignUpFixtures.today.addingTimeInterval(-86_400 * 365 * 5)
        #expect(viewModel.uiState?.birthDateError == "sign_up_birth_date_underage_txt")
    }

    @Test func nameEditingEndedCleansTheNameAndShowsItsError() {
        let viewModel = makeViewModel()
        viewModel.firstName = "CArlos arTURO"
        viewModel.maternalLastName = " de.  la cruz "
        viewModel.nameEditingEnded(.firstName)
        viewModel.nameEditingEnded(.maternalLastName)
        #expect(viewModel.firstName == "Carlos Arturo")
        #expect(viewModel.maternalLastName == "De La Cruz")
        viewModel.paternalLastName = "x"
        viewModel.nameEditingEnded(.paternalLastName)
        #expect(viewModel.uiState?.paternalLastNameError == "sign_up_name_invalid_txt")
    }

    @Test func validValuesContinueOnceAndStayInTheDraft() {
        let draft = SignUpDraft()
        var continues = 0
        let viewModel = makeViewModel(draft: draft, onContinue: { continues += 1 })
        fill(viewModel)
        viewModel.continueToContact()
        viewModel.uiState?.continueButton.action()
        #expect(continues == 1)
        #expect(draft.personal == SignUpFixtures.personal)
    }

    @Test func returningKeepsTheValuesForTheNextScreen() {
        let draft = SignUpDraft()
        var backs = 0
        let first = makeViewModel(draft: draft, onBack: { backs += 1 })
        fill(first)
        first.maternalLastName = "Pérez"
        first.goBack()
        first.goBack()
        #expect(backs == 1)

        let second = makeViewModel(draft: draft)
        #expect(second.firstName == "Ana")
        #expect(second.maternalLastName == "Pérez")
        #expect(second.birthDate == SignUpFixtures.adultBirthDate)
        #expect(second.uiState?.continueButton.isEnabled == true)
    }

    @Test func editsBeforeAppearanceAreIgnored() {
        let draft = SignUpDraft()
        let viewModel = PersonalInformationViewModel(draft: draft, onContinue: {}, onBack: {})
        viewModel.firstName = "Ana"
        #expect(viewModel.firstName.isEmpty)
        #expect(draft.personal.firstName.isEmpty)
    }
}
