import Foundation
import HKCore
import HKData
import HKDesignSystem
import HKDomain
import HKPresentation

/// Composition root. The only place that knows every layer: it registers
/// data sources, repositories and use cases in `HKContainer`, and hands the
/// presentation layer a `HKViewModelFactory` so views stay decoupled.
@MainActor
final class AppDependencies {
    private let container = HKContainer()

    init(defaults: UserDefaults = .standard, bundle: Bundle = .main) {
        registerData(defaults: defaults, bundle: bundle)
        registerDomain()
        registerDesignSystem(defaults: defaults)
    }

    var themeManager: HKThemeManager {
        container.resolve()
    }

    private func registerData(defaults: UserDefaults, bundle: Bundle) {
        container.register((any OnboardingLocalDataSource).self, lifetime: .singleton) { _ in
            UserDefaultsOnboardingDataSource(defaults: defaults)
        }
        container.register((any OnboardingRepository).self, lifetime: .singleton) {
            DefaultOnboardingRepository(localDataSource: $0.resolve())
        }
        container.register((any AuthRemoteDataSource).self, lifetime: .singleton) { _ in
            SupabaseAuthRemoteDataSource(configuration: SupabaseConfiguration(bundle: bundle))
        }
        container.register((any AuthRepository).self, lifetime: .singleton) {
            DefaultAuthRepository(remoteDataSource: $0.resolve())
        }
    }

    private func registerDomain() {
        container.register((any GetOnboardingStateUseCase).self) {
            DefaultGetOnboardingStateUseCase(repository: $0.resolve())
        }
        container.register((any CompleteOnboardingUseCase).self) {
            DefaultCompleteOnboardingUseCase(repository: $0.resolve())
        }
        container.register((any ResetOnboardingUseCase).self) {
            DefaultResetOnboardingUseCase(repository: $0.resolve())
        }
        container.register((any SignInUseCase).self) {
            DefaultSignInUseCase(repository: $0.resolve())
        }
        container.register((any SignUpUseCase).self) {
            DefaultSignUpUseCase(repository: $0.resolve())
        }
    }

    private func registerDesignSystem(defaults: UserDefaults) {
        container.register(HKThemeManager.self, lifetime: .singleton) { _ in
            HKThemeManager(defaults: defaults)
        }
    }
}

extension AppDependencies: HKViewModelFactory {
    func makeRootViewModel() -> RootViewModel {
        RootViewModel(getOnboardingState: container.resolve())
    }

    func makeWelcomeViewModel(onFinish: @escaping @MainActor () -> Void) -> WelcomeViewModel {
        WelcomeViewModel(completeOnboarding: container.resolve(), onFinish: onFinish)
    }

    func makeSignInViewModel(
        onSignUp: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void
    ) -> SignInViewModel {
        SignInViewModel(signIn: container.resolve(), onSignUp: onSignUp, onAuthenticated: onAuthenticated)
    }

    func makeSignUpViewModel(
        onStart: @escaping @MainActor () -> Void,
        onSignIn: @escaping @MainActor () -> Void
    ) -> SignUpViewModel {
        SignUpViewModel(onStart: onStart, onSignIn: onSignIn)
    }

    func makePersonalInformationViewModel(
        draft: SignUpDraft,
        onContinue: @escaping @MainActor () -> Void,
        onBack: @escaping @MainActor () -> Void
    ) -> PersonalInformationViewModel {
        PersonalInformationViewModel(draft: draft, onContinue: onContinue, onBack: onBack)
    }

    func makeContactInformationViewModel(
        draft: SignUpDraft,
        onBack: @escaping @MainActor () -> Void,
        onAuthenticated: @escaping @MainActor () -> Void,
        onConfirmationRequired: @escaping @MainActor () -> Void
    ) -> ContactInformationViewModel {
        ContactInformationViewModel(
            draft: draft,
            signUp: container.resolve(),
            onBack: onBack,
            onAuthenticated: onAuthenticated,
            onConfirmationRequired: onConfirmationRequired
        )
    }

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel()
    }

    func makeSettingsViewModel(onResetOnboarding: @escaping @MainActor () -> Void) -> SettingsViewModel {
        SettingsViewModel(resetOnboarding: container.resolve(), onResetOnboarding: onResetOnboarding)
    }
}
