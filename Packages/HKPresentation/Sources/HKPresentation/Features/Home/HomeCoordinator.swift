import Observation

/**
 * Navigation state of the home shell: the selected tab plus one router per
 * tab, so every tab remembers its own history while switching.
 */
@MainActor
@Observable
public final class HomeCoordinator {
    public private(set) var selectedTab: HomeTab
    public let dashboard: HKRouter<DashboardRoute>
    public let settings: HKRouter<SettingsRoute>

    public init(
        selectedTab: HomeTab = .dashboard,
        dashboard: HKRouter<DashboardRoute> = HKRouter(),
        settings: HKRouter<SettingsRoute> = HKRouter()
    ) {
        self.selectedTab = selectedTab
        self.dashboard = dashboard
        self.settings = settings
    }

    /**
     * Selects a tab. Tapping the tab that is already selected pops it to its
     * root, matching the system tab bar behavior.
     */
    public func select(_ tab: HomeTab) {
        if tab == selectedTab {
            popToRoot(tab)
        } else {
            selectedTab = tab
        }
    }

    /**
     * Jumps to any screen in any tab, replacing that tab's stack.
     */
    public func open(_ destination: HomeDestination) {
        switch destination {
        case .dashboard(let route):
            selectedTab = .dashboard
            dashboard.show(route.map { [$0] } ?? [])
        case .settings(let route):
            selectedTab = .settings
            settings.show(route.map { [$0] } ?? [])
        }
    }

    private func popToRoot(_ tab: HomeTab) {
        switch tab {
        case .dashboard: dashboard.popToRoot()
        case .settings: settings.popToRoot()
        }
    }
}
