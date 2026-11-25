import Foundation
import HKDomain
import HKPresentation
import Testing

private struct StubGetOnboardingState: GetOnboardingStateUseCase {
    let state: OnboardingState
    func execute() async -> OnboardingState { state }
}

private struct StubFailure: Error {}

private struct StubAction: CompleteOnboardingUseCase, ResetOnboardingUseCase {
    let fails: Bool
    func execute() async throws {
        if fails { throw StubFailure() }
    }
}

@MainActor
struct RootViewModelTests {
    @Test func pendingOnboardingShowsWelcome() async {
        let viewModel = RootViewModel(getOnboardingState: StubGetOnboardingState(state: .pending))
        #expect(viewModel.destination == .loading)
        await viewModel.load()
        #expect(viewModel.destination == .welcome)
    }

    @Test func completedOnboardingShowsHome() async {
        let viewModel = RootViewModel(getOnboardingState: StubGetOnboardingState(state: .completed))
        await viewModel.load()
        #expect(viewModel.destination == .home)
    }

    @Test func finishingOnboardingGoesThroughAuthToHome() {
        let viewModel = RootViewModel(getOnboardingState: StubGetOnboardingState(state: .pending))
        viewModel.onboardingFinished()
        #expect(viewModel.destination == .auth)
        viewModel.authenticated()
        #expect(viewModel.destination == .home)
        viewModel.onboardingReset()
        #expect(viewModel.destination == .welcome)
    }
}

@MainActor
struct WelcomeViewModelTests {
    @Test func successFinishesOnboarding() async {
        var finished = false
        let viewModel = WelcomeViewModel(completeOnboarding: StubAction(fails: false)) { finished = true }
        await viewModel.start()
        #expect(finished)
        #expect(viewModel.errorMessage == nil)
        #expect(!viewModel.isLoading)
    }

    @Test func failureShowsErrorAndStays() async {
        var finished = false
        let viewModel = WelcomeViewModel(completeOnboarding: StubAction(fails: true)) { finished = true }
        await viewModel.start()
        #expect(!finished)
        #expect(viewModel.errorMessage != nil)
        viewModel.dismissError()
        #expect(viewModel.errorMessage == nil)
    }
}

@MainActor
struct SettingsViewModelTests {
    @Test func resetReturnsToWelcome() async {
        var reset = false
        let viewModel = SettingsViewModel(resetOnboarding: StubAction(fails: false)) { reset = true }
        await viewModel.showWelcomeAgain()
        #expect(reset)
        #expect(!viewModel.isResetting)
    }

    @Test func resetFailureShowsError() async {
        var reset = false
        let viewModel = SettingsViewModel(resetOnboarding: StubAction(fails: true)) { reset = true }
        await viewModel.showWelcomeAgain()
        #expect(!reset)
        #expect(viewModel.errorMessage != nil)
    }
}

@MainActor
struct HomeViewModelTests {
    private func viewModel(hour: Int) throws -> HomeViewModel {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "UTC"))
        let date = try #require(calendar.date(from: DateComponents(year: 2026, month: 1, day: 1, hour: hour)))
        return HomeViewModel(now: { date }, calendar: calendar)
    }

    @Test(arguments: [
        (6, HomeViewModel.Greeting.morning),
        (11, .morning),
        (12, .afternoon),
        (18, .afternoon),
        (19, .evening),
        (2, .evening),
    ])
    func greetingFollowsTimeOfDay(hour: Int, expected: HomeViewModel.Greeting) throws {
        #expect(try viewModel(hour: hour).greeting == expected)
    }

}
