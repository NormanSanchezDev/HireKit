/// A screen anywhere in the home shell, for deep links and actions that jump
/// between tabs.
///
/// Pass it to ``HomeCoordinator/open(_:)``. A `nil` route opens the tab's root.
public enum HomeDestination: Hashable, Sendable {
    /// The dashboard tab, optionally with a screen pushed.
    case dashboard(DashboardRoute? = nil)

    /// The settings tab, optionally with a screen pushed.
    case settings(SettingsRoute? = nil)
}
