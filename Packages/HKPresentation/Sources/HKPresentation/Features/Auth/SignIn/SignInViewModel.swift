import HKDomain
import Observation
import SwiftUI

/// The state and actions of the sign-in screen.
///
/// The ViewModel prepares ``SignInUIState`` on first appearance, validates the
/// form, signs in through ``SignInUseCase`` and reports navigation through
/// callbacks, so it never sees a router.
@MainActor
@Observable
public final class SignInViewModel {
    /// The screen state, created by ``onAppear()``.
    public private(set) var uiState: SignInUIState?

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

    private let signInUseCase: any SignInUseCase
    private let onSignUp: @MainActor () -> Void
    private let onAuthenticated: @MainActor () -> Void

    /// Creates the ViewModel.
    ///
    /// - Parameters:
    ///   - signIn: The use case that checks the credentials.
    ///   - onSignUp: Called when the user wants to create an account.
    ///   - onAuthenticated: Called when sign-in succeeds.
    public init(
        signIn: any SignInUseCase,
        onSignUp: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void
    ) {
        signInUseCase = signIn
        self.onSignUp = onSignUp
        self.onAuthenticated = onAuthenticated
    }

    /// Prepares the screen once, preserving typed values and in-flight work
    /// on later appearances.
    public func onAppear() {
        guard uiState == nil else { return }
        uiState = SignInUIState(
            onSignIn: { [weak self] in
                Task { await self?.signIn() }
            },
            onCreateAccount: { [weak self] in
                self?.goToSignUp()
            }
        )
    }

    /// Validates the form and, when it is valid, signs in.
    ///
    /// It does nothing before ``onAppear()`` or while a request is in flight.
    public func signIn() async {
        guard let state = uiState, !state.isLoading else { return }
        let emailError = AuthInputValidator.emailError(state.email)
        let passwordError = AuthInputValidator.passwordError(state.password)
        uiState?.emailError = emailError
        uiState?.passwordError = passwordError
        guard emailError == nil, passwordError == nil else { return }

        uiState?.errorMessage = nil
        uiState?.isLoading = true
        defer { uiState?.isLoading = false }
        do throws(AuthenticationError) {
            _ = try await signInUseCase.execute(AuthCredentials(email: state.email, password: state.password))
            onAuthenticated()
        } catch {
            uiState?.errorMessage = error.message
        }
    }

    /// Opens the sign-up screen.
    public func goToSignUp() {
        onSignUp()
    }
}
