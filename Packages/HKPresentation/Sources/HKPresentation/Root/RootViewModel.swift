import HKDomain
import Observation

/// Decides which top-level flow the app shows. Switching flows replaces the
/// whole screen, so there is never a back button from home to sign in.
@MainActor
@Observable
public final class RootViewModel {
    public enum Destination: Equatable, Sendable {
        case loading
        case welcome
        case auth
        case home
    }

    public private(set) var destination: Destination = .loading

    private let getOnboardingState: any GetOnboardingStateUseCase

    public init(getOnboardingState: any GetOnboardingStateUseCase) {
        self.getOnboardingState = getOnboardingState
    }

    public func load() async {
        switch await getOnboardingState.execute() {
        case .pending: destination = .welcome
        case .completed: destination = .home
        }
    }

    public func onboardingFinished() {
        destination = .auth
    }

    public func authenticated() {
        destination = .home
    }

    public func onboardingReset() {
        destination = .welcome
    }
}
