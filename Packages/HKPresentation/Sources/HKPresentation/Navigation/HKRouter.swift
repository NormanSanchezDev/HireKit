import Observation

/// The navigation state of one flow: a push stack plus an optional sheet.
///
/// Use one router per `NavigationStack`. The router holds no views, so it is
/// easy to test and deep links can drive it:
///
/// ```swift
/// let router = HKRouter<SettingsRoute>()
/// router.push(.appearance)
/// router.present(.about)
/// router.show([.appearance])
/// ```
///
/// Render a router with `HKRouterStack`. ViewModels never receive a router;
/// the coordinator view turns their callbacks into router calls.
@MainActor
@Observable
public final class HKRouter<Route: HKRoute> {
    /// The pushed routes, from the first screen after the root to the top.
    public var path: [Route]

    /// The route presented as a sheet, if any.
    public var sheet: Route?

    /// Creates a router.
    ///
    /// - Parameters:
    ///   - path: The initial push stack.
    ///   - sheet: The initially presented sheet.
    public init(path: [Route] = [], sheet: Route? = nil) {
        self.path = path
        self.sheet = sheet
    }

    /// A Boolean value that indicates whether the root screen is on top.
    public var isAtRoot: Bool {
        path.isEmpty
    }

    /// Pushes a screen on top of the stack.
    ///
    /// - Parameter route: The screen to push.
    public func push(_ route: Route) {
        path.append(route)
    }

    /// Removes the top screen. Does nothing at the root.
    public func pop() {
        _ = path.popLast()
    }

    /// Removes every pushed screen.
    public func popToRoot() {
        path.removeAll()
    }

    /// Replaces the whole stack and dismisses any sheet, for deep links or
    /// state restoration.
    ///
    /// - Parameter routes: The new push stack.
    public func show(_ routes: [Route]) {
        sheet = nil
        path = routes
    }

    /// Presents a screen as a sheet.
    ///
    /// - Parameter route: The screen to present.
    public func present(_ route: Route) {
        sheet = route
    }

    /// Dismisses the presented sheet.
    public func dismiss() {
        sheet = nil
    }
}
