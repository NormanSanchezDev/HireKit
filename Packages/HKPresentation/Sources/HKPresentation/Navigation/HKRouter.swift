import Observation

/**
 * A destination inside one navigation flow. Each flow declares its own enum,
 * for example `AuthRoute` or `SettingsRoute`, so routes stay type-safe.
 */
public protocol HKRoute: Hashable, Identifiable, Sendable {}

extension HKRoute {
    public var id: Self { self }
}

/**
 * Navigation state for one flow: a push stack plus an optional sheet.
 * One router per `NavigationStack`; it holds no views, so it is easy to test
 * and can be driven by deep links through `show(_:)`.
 */
@MainActor
@Observable
public final class HKRouter<Route: HKRoute> {
    public var path: [Route]
    public var sheet: Route?

    public init(path: [Route] = [], sheet: Route? = nil) {
        self.path = path
        self.sheet = sheet
    }

    public var isAtRoot: Bool {
        path.isEmpty
    }

    public func push(_ route: Route) {
        path.append(route)
    }

    public func pop() {
        _ = path.popLast()
    }

    public func popToRoot() {
        path.removeAll()
    }

    /**
     * Replaces the whole stack at once, for deep links or state restoration.
     */
    public func show(_ routes: [Route]) {
        sheet = nil
        path = routes
    }

    public func present(_ route: Route) {
        sheet = route
    }

    public func dismiss() {
        sheet = nil
    }
}
