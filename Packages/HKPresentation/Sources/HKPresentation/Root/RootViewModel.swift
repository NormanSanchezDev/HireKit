import HKDomain
import Observation

/// Decides which top-level flow the app shows.
///
/// Switching flows replaces the whole screen, so there is never a back button
/// from home to sign in.
@MainActor
@Observable
public final class RootViewModel {
    /// A top-level flow.
    public enum Destination: Equatable, Sendable {
        /// The stored progress is still loading.
        case loading

        /// The welcome flow, for new users.
        case welcome

        /// Sign in and sign up.
        case auth

        /// The home shell with its tabs.
        case home
    }

    /// The flow on screen.
    public private(set) var destination: Destination = .loading

    private let getOnboardingState: any GetOnboardingStateUseCase

    /// Creates the ViewModel.
    ///
    /// - Parameter getOnboardingState: The use case that reads onboarding progress.
    public init(getOnboardingState: any GetOnboardingStateUseCase) {
        self.getOnboardingState = getOnboardingState
    }

    /// Reads stored progress and picks the first flow.
    public func load() async {
        switch await getOnboardingState.execute() {
        case .pending: destination = .welcome
        case .completed: destination = .home
        }
    }

    /// Moves from the welcome flow to auth.
    public func onboardingFinished() {
        destination = .auth
    }

    /// Moves from auth to home.
    public func authenticated() {
        destination = .home
    }

    /// Moves back to the welcome flow after a reset from settings.
    public func onboardingReset() {
        destination = .welcome
    }
}
