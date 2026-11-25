import HKDesignSystem
import SwiftUI

/// The home shell.
///
/// A system `TabView` renders the floating Liquid Glass tab bar on iPhone, and
/// `sidebarAdaptable` turns it into a glass sidebar on iPad and Mac. Every tab
/// is an `HKRouterStack` driven by ``HomeCoordinator``, so each one keeps its
/// own history.
struct HomeView: View {
    @State private var coordinator: HomeCoordinator
    @State private var viewModel: HomeViewModel
    @State private var settingsViewModel: SettingsViewModel

    init(
        viewModel: HomeViewModel,
        settingsViewModel: SettingsViewModel,
        coordinator: HomeCoordinator = HomeCoordinator()
    ) {
        _viewModel = State(initialValue: viewModel)
        _settingsViewModel = State(initialValue: settingsViewModel)
        _coordinator = State(initialValue: coordinator)
    }

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            Tab("Inicio", systemImage: "house", value: HomeTab.dashboard) {
                HKRouterStack(router: coordinator.dashboard) {
                    DashboardView(greeting: viewModel.greeting) {
                        coordinator.dashboard.push(.notifications)
                    }
                } destination: { route in
                    dashboardScreen(for: route)
                }
            }

            Tab("Ajustes", systemImage: "gearshape", value: HomeTab.settings) {
                HKRouterStack(router: coordinator.settings) {
                    SettingsView(
                        viewModel: settingsViewModel,
                        onOpenAppearance: { coordinator.settings.push(.appearance) },
                        onOpenAbout: { coordinator.settings.present(.about) }
                    )
                } destination: { route in
                    settingsScreen(for: route)
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        #if os(iOS)
        .tabBarMinimizeBehavior(.onScrollDown)
        #endif
    }

    @ViewBuilder
    private func dashboardScreen(for route: DashboardRoute) -> some View {
        switch route {
        case .notifications:
            NotificationsView()
        }
    }

    @ViewBuilder
    private func settingsScreen(for route: SettingsRoute) -> some View {
        switch route {
        case .appearance:
            AppearanceView()
        case .about:
            AboutView { coordinator.settings.dismiss() }
        }
    }
}

#if DEBUG
#Preview("Home") {
    let factory = HKPreviewViewModelFactory()
    HomeView(
        viewModel: factory.makeHomeViewModel(),
        settingsViewModel: factory.makeSettingsViewModel {}
    )
    .environment(HKThemeManager(defaults: nil))
}
#endif
