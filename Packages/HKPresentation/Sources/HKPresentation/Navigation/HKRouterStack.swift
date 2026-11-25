import SwiftUI

/**
 * `NavigationStack` bound to an `HKRouter`. A flow only supplies its root
 * screen and one builder that maps every route to a screen; pushes and
 * sheets both go through that same builder.
 */
struct HKRouterStack<Route: HKRoute, Root: View, Destination: View>: View {
    @Bindable private var router: HKRouter<Route>
    private let root: Root
    private let destination: (Route) -> Destination

    init(
        router: HKRouter<Route>,
        @ViewBuilder root: () -> Root,
        @ViewBuilder destination: @escaping (Route) -> Destination
    ) {
        self.router = router
        self.root = root()
        self.destination = destination
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            root.navigationDestination(for: Route.self, destination: destination)
        }
        .sheet(item: $router.sheet) { route in
            NavigationStack { destination(route) }
        }
    }
}
