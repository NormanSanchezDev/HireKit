import HKDomain
import Observation

/**
 * Decides which top-level flow the app shows.
 */
@MainActor
@Observable
public final class RootViewModel {
    public enum Destination: Equatable, Sendable {
        case loading
        case welcome
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
        destination = .home
    }

    public func onboardingReset() {
        destination = .welcome
    }
}
