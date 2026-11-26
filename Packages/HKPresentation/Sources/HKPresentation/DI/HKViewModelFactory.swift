/// A factory for every ViewModel of the presentation layer.
///
/// The app's composition root implements it, so views never know how use
/// cases are wired. Previews use ``HKPreviewViewModelFactory``.
@MainActor
public protocol HKViewModelFactory: AnyObject {
    /// Returns the ViewModel that picks the top-level flow.
    func makeRootViewModel() -> RootViewModel

    /// Returns the ViewModel of the welcome screen.
    ///
    /// - Parameter onFinish: Called when the user finishes the welcome flow.
    func makeWelcomeViewModel(onFinish: @escaping @MainActor () -> Void) -> WelcomeViewModel

    /// Returns the ViewModel of the sign-in screen.
    ///
    /// - Parameters:
    ///   - onSignUp: Called when the user wants to create an account.
    ///   - onAuthenticated: Called when sign-in succeeds.
    func makeSignInViewModel(
        onSignUp: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void
    ) -> SignInViewModel

    /// Returns the ViewModel of the sign-up introduction.
    ///
    /// - Parameters:
    ///   - onStart: Called when the user starts the registration.
    ///   - onSignIn: Called when the user already has an account.
    func makeSignUpViewModel(
        onStart: @escaping @MainActor () -> Void,
        onSignIn: @escaping @MainActor () -> Void
    ) -> SignUpViewModel

    /// Returns the ViewModel of the personal information step of sign-up.
    ///
    /// - Parameters:
    ///   - draft: The values shared by the sign-up steps.
    ///   - onContinue: Called when the step is valid and the user continues.
    ///   - onBack: Called when the user returns to the introduction.
    func makePersonalInformationViewModel(
        draft: SignUpDraft,
        onContinue: @escaping @MainActor () -> Void,
        onBack: @escaping @MainActor () -> Void
    ) -> PersonalInformationViewModel

    /// Returns the ViewModel of the contact information step of sign-up,
    /// which creates the account.
    ///
    /// - Parameters:
    ///   - draft: The values shared by the sign-up steps.
    ///   - onBack: Called when the user returns to the personal information step.
    ///   - onAuthenticated: Called when the account is created with a session.
    ///   - onConfirmationRequired: Called after the user acknowledges that the
    ///     email must be confirmed before signing in.
    func makeContactInformationViewModel(
        draft: SignUpDraft,
        onBack: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void,
        onConfirmationRequired: @escaping @MainActor () -> Void
    ) -> ContactInformationViewModel

    /// Returns the ViewModel of the dashboard tab.
    func makeHomeViewModel() -> HomeViewModel

    /// Returns the ViewModel of the settings tab.
    ///
    /// - Parameter onResetOnboarding: Called after the welcome flow is reset.
    func makeSettingsViewModel(onResetOnboarding: @escaping @MainActor () -> Void) -> SettingsViewModel
}
