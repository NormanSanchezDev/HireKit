import Foundation
import HKDomain
import Observation

/// The state and actions of the personal information step of sign-up.
///
/// The ViewModel seeds ``PersonalInformationUIState`` from the shared
/// ``SignUpDraft``, writes every change back to it, validates each name when
/// its field loses focus and opens the next step only when every value is
/// valid. It never creates the account.
@MainActor
@Observable
public final class PersonalInformationViewModel {
    /// The screen state, created by ``onAppear()``.
    public private(set) var uiState: PersonalInformationUIState?

    /// The given names the person typed. Edits before ``onAppear()`` are ignored.
    public var firstName: String {
        get { uiState?.personal.firstName ?? "" }
        set { update { $0.firstName = newValue } }
    }

    /// The paternal surname the person typed. Edits before ``onAppear()`` are
    /// ignored.
    public var paternalLastName: String {
        get { uiState?.personal.paternalLastName ?? "" }
        set { update { $0.paternalLastName = newValue } }
    }

    /// The maternal surname the person typed. Edits before ``onAppear()`` are
    /// ignored.
    public var maternalLastName: String {
        get { uiState?.personal.maternalLastName ?? "" }
        set { update { $0.maternalLastName = newValue } }
    }

    /// The date of birth the person entered. A complete date shows its
    /// validation message at once. Edits before ``onAppear()`` are ignored.
    public var birthDate: Date? {
        get { uiState?.personal.birthDate }
        set {
            update { $0.birthDate = newValue }
            let today = currentDate()
            let error = newValue.flatMap { PersonalInformationValidator.birthDateError($0, today: today) }
            uiState?.birthDateError = error
        }
    }

    private let draft: SignUpDraft
    private let currentDate: () -> Date
    private let onContinue: @MainActor () -> Void
    private let onBack: @MainActor () -> Void
    private var hasRequestedNavigation = false

    /// Creates the ViewModel.
    ///
    /// - Parameters:
    ///   - draft: The values shared by the sign-up steps.
    ///   - currentDate: Returns today's date, for the age rules.
    ///   - onContinue: Called when every value is valid and the person
    ///     continues.
    ///   - onBack: Called when the person returns to the introduction.
    public init(
        draft: SignUpDraft,
        currentDate: @escaping () -> Date = { .now },
        onContinue: @escaping @MainActor () -> Void,
        onBack: @escaping @MainActor () -> Void
    ) {
        self.draft = draft
        self.currentDate = currentDate
        self.onContinue = onContinue
        self.onBack = onBack
    }

    /// Prepares the screen from the draft on first appearance.
    ///
    /// Later appearances keep the typed values and allow navigation again.
    public func onAppear() {
        hasRequestedNavigation = false
        guard uiState == nil else { return }
        uiState = PersonalInformationUIState(
            personal: draft.personal,
            birthDateRange: BirthDateRule.allowedRange(today: currentDate()),
            onContinue: { [weak self] in self?.continueToContact() },
            onBack: { [weak self] in self?.goBack() }
        )
        refreshAvailability()
    }

    /// Cleans a name after its field loses focus and shows its validation
    /// message.
    ///
    /// - Parameter field: The name field that lost focus.
    public func nameEditingEnded(_ field: PersonalInformationField) {
        switch field {
        case .firstName:
            let cleaned = PersonName.cleaned(firstName)
            firstName = cleaned
            uiState?.firstNameError = PersonalInformationValidator.requiredNameError(cleaned)
        case .paternalLastName:
            let cleaned = PersonName.cleaned(paternalLastName)
            paternalLastName = cleaned
            uiState?.paternalLastNameError = PersonalInformationValidator.requiredNameError(cleaned)
        case .maternalLastName:
            let cleaned = PersonName.cleaned(maternalLastName)
            maternalLastName = cleaned
            uiState?.maternalLastNameError = PersonalInformationValidator.optionalNameError(cleaned)
        }
    }

    /// Cleans and validates every value and, when they are valid, opens the
    /// contact step. Repeated calls navigate only once.
    public func continueToContact() {
        guard uiState != nil, !hasRequestedNavigation else { return }
        nameEditingEnded(.firstName)
        nameEditingEnded(.paternalLastName)
        nameEditingEnded(.maternalLastName)
        let birthDateError = PersonalInformationValidator.birthDateError(birthDate, today: currentDate())
        uiState?.birthDateError = birthDateError
        guard uiState?.canContinue == true else { return }
        hasRequestedNavigation = true
        onContinue()
    }

    /// Returns to the introduction. The draft keeps the typed values.
    public func goBack() {
        guard uiState != nil, !hasRequestedNavigation else { return }
        hasRequestedNavigation = true
        onBack()
    }

    private func update(_ change: (inout PersonalInformation) -> Void) {
        guard var personal = uiState?.personal else { return }
        change(&personal)
        uiState?.personal = personal
        draft.personal = personal
        refreshAvailability()
    }

    private func refreshAvailability() {
        guard let personal = uiState?.personal else { return }
        let canContinue = PersonalInformationValidator.isValid(personal, today: currentDate())
        uiState?.canContinue = canContinue
    }
}
