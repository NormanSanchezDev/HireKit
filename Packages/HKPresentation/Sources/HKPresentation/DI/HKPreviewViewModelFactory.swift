#if DEBUG
import HKDomain

/**
 * In-memory factory for SwiftUI previews. Never ships: it only exists in
 * DEBUG builds and stores nothing on disk.
 */
@MainActor
public final class HKPreviewViewModelFactory: HKViewModelFactory {
    private let repository: PreviewOnboardingRepository

    public init(initialState: OnboardingState = .pending) {
        repository = PreviewOnboardingRepository(state: initialState)
    }

    public func makeRootViewModel() -> RootViewModel {
        RootViewModel(getOnboardingState: DefaultGetOnboardingStateUseCase(repository: repository))
    }

    public func makeWelcomeViewModel(onFinish: @escaping @MainActor () -> Void) -> WelcomeViewModel {
        WelcomeViewModel(
            completeOnboarding: DefaultCompleteOnboardingUseCase(repository: repository),
            onFinish: onFinish
        )
    }

    public func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel()
    }

    public func makeSettingsViewModel(onResetOnboarding: @escaping @MainActor () -> Void) -> SettingsViewModel {
        SettingsViewModel(
            resetOnboarding: DefaultResetOnboardingUseCase(repository: repository),
            onResetOnboarding: onResetOnboarding
        )
    }
}

private actor PreviewOnboardingRepository: OnboardingRepository {
    private var state: OnboardingState

    init(state: OnboardingState) {
        self.state = state
    }

    func currentState() -> OnboardingState { state }
    func save(_ state: OnboardingState) { self.state = state }
}
#endif
