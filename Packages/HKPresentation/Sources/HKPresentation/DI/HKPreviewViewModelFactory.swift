#if DEBUG
import HKDomain

/// An in-memory ``HKViewModelFactory`` for SwiftUI previews.
///
/// It exists only in DEBUG builds and stores nothing on disk.
@MainActor
public final class HKPreviewViewModelFactory: HKViewModelFactory {
    private let repository: PreviewOnboardingRepository
    private let authRepository = PreviewAuthRepository()

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

    /// Returns a sign-in ViewModel that accepts any valid-looking credentials.
    public func makeSignInViewModel(
        onSignUp: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void
    ) -> SignInViewModel {
        SignInViewModel(
            signIn: DefaultSignInUseCase(repository: authRepository),
            onSignUp: onSignUp,
            onAuthenticated: onAuthenticated
        )
    }

    /// Returns a sign-up introduction ViewModel with the default timer.
    public func makeSignUpViewModel(
        onStart: @escaping @MainActor () -> Void,
        onSignIn: @escaping @MainActor () -> Void
    ) -> SignUpViewModel {
        SignUpViewModel(onStart: onStart, onSignIn: onSignIn)
    }

    /// Returns a personal information ViewModel that uses the current date.
    public func makePersonalInformationViewModel(
        draft: SignUpDraft,
        onContinue: @escaping @MainActor () -> Void,
        onBack: @escaping @MainActor () -> Void
    ) -> PersonalInformationViewModel {
        PersonalInformationViewModel(draft: draft, onContinue: onContinue, onBack: onBack)
    }

    /// Returns a contact information ViewModel whose sign-up always asks to
    /// confirm the email.
    public func makeContactInformationViewModel(
        draft: SignUpDraft,
        onBack: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void,
        onConfirmationRequired: @escaping @MainActor () -> Void
    ) -> ContactInformationViewModel {
        ContactInformationViewModel(
            draft: draft,
            signUp: DefaultSignUpUseCase(repository: authRepository),
            onBack: onBack,
            onAuthenticated: onAuthenticated,
            onConfirmationRequired: onConfirmationRequired
        )
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
