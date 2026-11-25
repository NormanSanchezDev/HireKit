#if DEBUG
import HKDomain

/// An in-memory `OnboardingRepository` used by ``HKPreviewViewModelFactory``.
actor PreviewOnboardingRepository: OnboardingRepository {
    private var state: OnboardingState

    init(state: OnboardingState) {
        self.state = state
    }

    func currentState() -> OnboardingState { state }

    func save(_ state: OnboardingState) { self.state = state }
}
#endif
