import Observation

/// The navigation state of the home shell: the selected tab plus one router
/// per tab, so every tab remembers its own history while switching.
///
/// Bind `TabView(selection:)` to ``selectedTab``. Selecting the tab that is
/// already selected pops it to its root, like the system tab bar.
@MainActor
@Observable
public final class HomeCoordinator {
    /// The router of the dashboard tab.
    public let dashboard: HKRouter<DashboardRoute>

    /// The router of the settings tab.
    public let settings: HKRouter<SettingsRoute>

    private var currentTab: HomeTab

    /// Creates a coordinator.
    ///
    /// - Parameters:
    ///   - selectedTab: The tab shown first.
    ///   - dashboard: The router of the dashboard tab.
    ///   - settings: The router of the settings tab.
    public init(
        selectedTab: HomeTab = .dashboard,
        dashboard: HKRouter<DashboardRoute> = HKRouter(),
        settings: HKRouter<SettingsRoute> = HKRouter()
    ) {
        self.currentTab = selectedTab
        self.dashboard = dashboard
        self.settings = settings
    }

    /// The selected tab. Setting the tab that is already selected pops it to
    /// its root.
    public var selectedTab: HomeTab {
        get { currentTab }
        set { select(newValue) }
    }

    /// Selects a tab, or pops it to its root when it is already selected.
    ///
    /// - Parameter tab: The tab to select.
    public func select(_ tab: HomeTab) {
        if tab == currentTab {
            popToRoot(tab)
        } else {
            currentTab = tab
        }
    }

    /// Jumps to any screen in any tab, replacing that tab's stack.
    ///
    /// - Parameter destination: The screen to show.
    public func open(_ destination: HomeDestination) {
        switch destination {
        case .dashboard(let route):
            currentTab = .dashboard
            dashboard.show(route.map { [$0] } ?? [])
        case .settings(let route):
            currentTab = .settings
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
