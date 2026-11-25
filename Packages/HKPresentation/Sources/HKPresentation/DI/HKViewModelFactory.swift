/**
 * Builds every ViewModel the presentation layer needs. The app's composition
 * root implements it, so views never know how use cases are wired.
 */
@MainActor
public protocol HKViewModelFactory: AnyObject {
    func makeRootViewModel() -> RootViewModel
    func makeWelcomeViewModel(onFinish: @escaping @MainActor () -> Void) -> WelcomeViewModel
    func makeSignInViewModel(
        onSignUp: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void
    ) -> SignInViewModel
    func makeSignUpViewModel(onAuthenticated: @escaping @MainActor () -> Void) -> SignUpViewModel
    func makeHomeViewModel() -> HomeViewModel
    func makeSettingsViewModel(onResetOnboarding: @escaping @MainActor () -> Void) -> SettingsViewModel
}
