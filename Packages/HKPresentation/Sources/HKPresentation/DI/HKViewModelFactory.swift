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

    /// Returns the ViewModel of the sign-up screen.
    ///
    /// - Parameter onAuthenticated: Called when sign-up succeeds.
    func makeSignUpViewModel(onAuthenticated: @escaping @MainActor () -> Void) -> SignUpViewModel

    /// Returns the ViewModel of the dashboard tab.
    func makeHomeViewModel() -> HomeViewModel

    /// Returns the ViewModel of the settings tab.
    ///
    /// - Parameter onResetOnboarding: Called after the welcome flow is reset.
    func makeSettingsViewModel(onResetOnboarding: @escaping @MainActor () -> Void) -> SettingsViewModel
}
