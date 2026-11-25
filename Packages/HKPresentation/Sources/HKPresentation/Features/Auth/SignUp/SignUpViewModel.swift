import Foundation
import HKDomain
import Observation
import SwiftUI

/// The state and actions of the sign-up screen.
///
/// The ViewModel prepares ``SignUpUIState`` on first appearance, cleans names
/// when their field loses focus, validates the form, creates the account
/// through ``SignUpUseCase`` and reports navigation through callbacks.
@MainActor
@Observable
public final class SignUpViewModel {
    /// The screen state, created by ``onAppear()``.
    public private(set) var uiState: SignUpUIState?

    /// The given names the user typed. Edits before ``onAppear()`` are ignored.
    public var firstName: String {
        get { uiState?.firstName ?? "" }
        set { uiState?.firstName = newValue }
    }

    /// The paternal surname the user typed. Edits before ``onAppear()`` are
    /// ignored.
    public var paternalLastName: String {
        get { uiState?.paternalLastName ?? "" }
        set { uiState?.paternalLastName = newValue }
    }

    /// The maternal surname the user typed. Edits before ``onAppear()`` are
    /// ignored.
    public var maternalLastName: String {
        get { uiState?.maternalLastName ?? "" }
        set { uiState?.maternalLastName = newValue }
    }

    /// The date of birth the user picked. Edits before ``onAppear()`` are
    /// ignored.
    public var birthDate: Date? {
        get { uiState?.birthDate }
        set { uiState?.birthDate = newValue }
    }

    /// The calling code of the phone number. Edits before ``onAppear()`` are
    /// ignored.
    public var dialCode: DialCode {
        get { uiState?.dialCode ?? .mexico }
        set { uiState?.dialCode = newValue }
    }

    /// The national phone number, digits only. Edits before ``onAppear()``
    /// are ignored.
    public var phoneDigits: String {
        get { uiState?.phoneDigits ?? "" }
        set { uiState?.phoneDigits = newValue }
    }

    /// The email the user typed. Edits before ``onAppear()`` are ignored.
    public var email: String {
        get { uiState?.email ?? "" }
        set { uiState?.email = newValue }
    }

    /// The password the user typed. Edits before ``onAppear()`` are ignored.
    public var password: String {
        get { uiState?.password ?? "" }
        set { uiState?.password = newValue }
    }

    /// A Boolean value that indicates whether the error alert is showing.
    /// Setting it to `false` clears the error.
    public var isShowingError: Bool {
        get { uiState?.errorMessage != nil }
        set { if !newValue { uiState?.errorMessage = nil } }
    }

    /// A Boolean value that indicates whether the confirmation alert is
    /// showing. Setting it to `false` clears the pending address.
    public var isShowingConfirmation: Bool {
        get { uiState?.pendingConfirmationEmail != nil }
        set { if !newValue { uiState?.pendingConfirmationEmail = nil } }
    }

    private let signUpUseCase: any SignUpUseCase
    private let currentDate: () -> Date
    private let onAuthenticated: @MainActor () -> Void
    private let onConfirmationRequired: @MainActor () -> Void

    /// Creates the ViewModel.
    ///
    /// - Parameters:
    ///   - signUp: The use case that creates the account.
    ///   - currentDate: Returns today's date, for the minimum age.
    ///   - onAuthenticated: Called when the account is created with a session.
    ///   - onConfirmationRequired: Called after the user acknowledges that the
    ///     email must be confirmed before signing in.
    public init(
        signUp: any SignUpUseCase,
        currentDate: @escaping () -> Date = { .now },
        onAuthenticated: @escaping @MainActor () -> Void,
        onConfirmationRequired: @escaping @MainActor () -> Void
    ) {
        signUpUseCase = signUp
        self.currentDate = currentDate
        self.onAuthenticated = onAuthenticated
        self.onConfirmationRequired = onConfirmationRequired
    }

    /// Prepares the screen once, preserving typed values and in-flight work
    /// on later appearances.
    public func onAppear() {
        guard uiState == nil else { return }
        uiState = SignUpUIState(
            birthDateRange: BirthDateRule.allowedRange(today: currentDate()),
            onSignUp: { [weak self] in
                Task { await self?.signUp() }
            },
            onConfirmationAcknowledged: { [weak self] in
                self?.acknowledgeConfirmation()
            }
        )
    }

    /// Cleans a name after its field loses focus: removes punctuation and
    /// extra spaces and capitalizes each word.
    ///
    /// - Parameter field: The name field that lost focus.
    public func nameEditingEnded(_ field: SignUpNameField) {
        switch field {
        case .firstName: firstName = PersonName.cleaned(firstName)
        case .paternalLastName: paternalLastName = PersonName.cleaned(paternalLastName)
        case .maternalLastName: maternalLastName = PersonName.cleaned(maternalLastName)
        }
    }

    /// Cleans the names, validates the form and, when it is valid, creates
    /// the account.
    ///
    /// It does nothing before ``onAppear()`` or while a request is in flight.
    public func signUp() async {
        guard let current = uiState, !current.isLoading else { return }
        nameEditingEnded(.firstName)
        nameEditingEnded(.paternalLastName)
        nameEditingEnded(.maternalLastName)
        guard let account = validatedAccount() else { return }

        uiState?.errorMessage = nil
        uiState?.isLoading = true
        defer { uiState?.isLoading = false }
        do throws(AuthenticationError) {
            switch try await signUpUseCase.execute(account) {
            case .signedIn:
                onAuthenticated()
            case let .confirmationRequired(email):
                uiState?.pendingConfirmationEmail = email
            }
        } catch {
            uiState?.errorMessage = error.message
        }
    }

    /// Closes the confirmation alert and returns to sign in.
    public func acknowledgeConfirmation() {
        uiState?.pendingConfirmationEmail = nil
        onConfirmationRequired()
    }

    private func validatedAccount() -> NewAccount? {
        guard var state = uiState else { return nil }
        state.firstNameError = AuthInputValidator.requiredNameError(state.firstName)
        state.paternalLastNameError = AuthInputValidator.requiredNameError(state.paternalLastName)
        state.maternalLastNameError = AuthInputValidator.optionalNameError(state.maternalLastName)
        state.birthDateError = AuthInputValidator.birthDateError(state.birthDate, today: currentDate())
        state.phoneError = AuthInputValidator.phoneError(state.phoneDigits)
        state.emailError = AuthInputValidator.emailError(state.email)
        state.passwordError = AuthInputValidator.passwordError(state.password)
        uiState = state

        let hasErrors = [
            state.firstNameError, state.paternalLastNameError, state.maternalLastNameError,
            state.birthDateError, state.phoneError, state.emailError, state.passwordError,
        ].contains { $0 != nil }
        guard !hasErrors,
              let birthDate = state.birthDate,
              let phone = PhoneNumber(dialCode: state.dialCode, digits: state.phoneDigits)
        else { return nil }

        return NewAccount(
            firstName: state.firstName,
            paternalLastName: state.paternalLastName,
            maternalLastName: state.maternalLastName.isEmpty ? nil : state.maternalLastName,
            birthDate: birthDate,
            phone: phone,
            credentials: AuthCredentials(email: state.email, password: state.password)
        )
    }
}
