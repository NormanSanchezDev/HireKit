#if DEBUG
import HKDomain

/// An in-memory ``HKViewModelFactory`` for SwiftUI previews.
///
/// It exists only in DEBUG builds and stores nothing on disk.
@MainActor
public final class HKPreviewViewModelFactory: HKViewModelFactory {
    private let repository: PreviewOnboardingRepository

    /// Creates a preview factory.
    ///
    /// - Parameter initialState: The onboarding progress previews start with.
    public init(initialState: OnboardingState = .pending) {
        repository = PreviewOnboardingRepository(state: initialState)
    }

    /// Returns a root ViewModel backed by in-memory progress.
    public func makeRootViewModel() -> RootViewModel {
        RootViewModel(getOnboardingState: DefaultGetOnboardingStateUseCase(repository: repository))
    }

    /// Returns a welcome ViewModel backed by in-memory progress.
    public func makeWelcomeViewModel(onFinish: @escaping @MainActor () -> Void) -> WelcomeViewModel {
        WelcomeViewModel(
            completeOnboarding: DefaultCompleteOnboardingUseCase(repository: repository),
            onFinish: onFinish
        )
    }

    /// Returns a sign-in ViewModel.
    public func makeSignInViewModel(
        onSignUp: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void
    ) -> SignInViewModel {
        SignInViewModel(onSignUp: onSignUp, onAuthenticated: onAuthenticated)
    }

    /// Returns a sign-up ViewModel.
    public func makeSignUpViewModel(onAuthenticated: @escaping @MainActor () -> Void) -> SignUpViewModel {
        SignUpViewModel(onAuthenticated: onAuthenticated)
    }

    /// Returns a dashboard ViewModel that uses the current time.
    public func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel()
    }

    /// Returns a settings ViewModel backed by in-memory progress.
    public func makeSettingsViewModel(onResetOnboarding: @escaping @MainActor () -> Void) -> SettingsViewModel {
        SettingsViewModel(
            resetOnboarding: DefaultResetOnboardingUseCase(repository: repository),
            onResetOnboarding: onResetOnboarding
        )
    }
}
#endif
