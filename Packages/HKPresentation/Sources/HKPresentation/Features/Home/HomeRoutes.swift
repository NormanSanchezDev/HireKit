/// Tabs of the home shell. Each tab keeps its own navigation stack.
public enum HomeTab: Hashable, Sendable, CaseIterable {
    case dashboard
    case settings
}

/// Screens reachable from the dashboard tab.
public enum DashboardRoute: HKRoute {
    case notifications
}

/// Screens reachable from the settings tab.
public enum SettingsRoute: HKRoute {
    case appearance
    case about
}

/// Cross-tab destinations, for deep links or actions that jump between tabs.
public enum HomeDestination: Hashable, Sendable {
    case dashboard(DashboardRoute? = nil)
    case settings(SettingsRoute? = nil)
}
