import HKPresentation
import Testing

@MainActor
struct HKRouterTests {
    @Test func pushPopAndPopToRoot() {
        let router = HKRouter<SettingsRoute>()
        #expect(router.isAtRoot)
        router.push(.appearance)
        router.push(.about)
        #expect(router.path == [.appearance, .about])
        router.pop()
        #expect(router.path == [.appearance])
        router.popToRoot()
        #expect(router.isAtRoot)
    }

    @Test func signUpStepsPushAndReturnInFlowOrder() {
        let router = HKRouter<AuthRoute>()
        router.push(.signUp)
        router.push(.personalInformation)
        router.push(.contactInformation)
        #expect(router.path == [.signUp, .personalInformation, .contactInformation])
        router.pop()
        #expect(router.path == [.signUp, .personalInformation])
        router.popToRoot()
        #expect(router.isAtRoot)
    }

    @Test func popOnEmptyStackIsSafe() {
        let router = HKRouter<AuthRoute>()
        router.pop()
        #expect(router.isAtRoot)
    }

    @Test func presentAndDismissSheet() {
        let router = HKRouter<SettingsRoute>()
        router.present(.about)
        #expect(router.sheet == .about)
        router.dismiss()
        #expect(router.sheet == nil)
    }

    @Test func showReplacesStackAndClosesSheet() {
        let router = HKRouter<SettingsRoute>(path: [.about], sheet: .about)
        router.show([.appearance])
        #expect(router.path == [.appearance])
        #expect(router.sheet == nil)
    }
}

@MainActor
struct HomeCoordinatorTests {
    @Test func startsOnDashboardWithEmptyStacks() {
        let coordinator = HomeCoordinator()
        #expect(coordinator.selectedTab == .dashboard)
        #expect(coordinator.dashboard.isAtRoot)
        #expect(coordinator.settings.isAtRoot)
    }

    @Test func tabsKeepTheirOwnHistory() {
        let coordinator = HomeCoordinator()
        coordinator.dashboard.push(.notifications)
        coordinator.select(.settings)
        coordinator.settings.push(.appearance)
        coordinator.select(.dashboard)
        #expect(coordinator.dashboard.path == [.notifications])
        #expect(coordinator.settings.path == [.appearance])
    }

    @Test func reselectingCurrentTabPopsToRoot() {
        let coordinator = HomeCoordinator()
        coordinator.dashboard.push(.notifications)
        coordinator.select(.dashboard)
        #expect(coordinator.dashboard.isAtRoot)
    }

    @Test func tabBindingSetterReselectsLikeTheTabBar() {
        let coordinator = HomeCoordinator()
        coordinator.settings.push(.appearance)
        coordinator.selectedTab = .settings
        #expect(coordinator.selectedTab == .settings)
        #expect(coordinator.settings.path == [.appearance])
        coordinator.selectedTab = .settings
        #expect(coordinator.settings.isAtRoot)
    }

    @Test func openJumpsAcrossTabs() {
        let coordinator = HomeCoordinator()
        coordinator.open(.settings(.appearance))
        #expect(coordinator.selectedTab == .settings)
        #expect(coordinator.settings.path == [.appearance])
        coordinator.open(.dashboard())
        #expect(coordinator.selectedTab == .dashboard)
        #expect(coordinator.dashboard.isAtRoot)
    }
}
