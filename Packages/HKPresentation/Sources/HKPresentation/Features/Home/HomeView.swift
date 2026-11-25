import HKDesignSystem
import SwiftUI

/**
 * Home shell. A `TabView` on iOS 26 and later renders the floating Liquid
 * Glass bottom bar on iPhone, and `sidebarAdaptable` turns it into a glass
 * sidebar on iPad and Mac. Every tab is an `HKRouterStack` driven by
 * `HomeCoordinator`, so each one keeps its own history.
 */
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
        TabView(selection: selection) {
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

    private var selection: Binding<HomeTab> {
        Binding(get: { coordinator.selectedTab }, set: { coordinator.select($0) })
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

private struct DashboardView: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    let greeting: HomeViewModel.Greeting
    let onOpenNotifications: () -> Void

    var body: some View {
        let spacing = themeManager.current(for: colorScheme).spacing
        ScrollView {
            HKGlassGroup(spacing: spacing.large) {
                VStack(spacing: spacing.large) {
                    HKGlassCard {
                        VStack(alignment: .leading, spacing: spacing.small) {
                            HKLabel(model: .init(text: greetingText, type: .title))
                            HKLabel(model: .init(text: "Este es el resumen de tu búsqueda.", type: .subheadline))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HKGlassCard {
                        ContentUnavailableView(
                            "Sin procesos activos",
                            systemImage: "tray",
                            description: Text("Cuando inicies un proceso de contratación aparecerá aquí.")
                        )
                    }
                }
            }
            .padding(spacing.extraLarge)
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Inicio")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Notificaciones", systemImage: "bell", action: onOpenNotifications)
            }
        }
        .hkBackdrop()
    }

    private var greetingText: LocalizedStringKey {
        switch greeting {
        case .morning: "Buenos días"
        case .afternoon: "Buenas tardes"
        case .evening: "Buenas noches"
        }
    }
}

private struct NotificationsView: View {
    var body: some View {
        ContentUnavailableView(
            "Sin notificaciones",
            systemImage: "bell.slash",
            description: Text("Te avisaremos cuando haya novedades en tus procesos.")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Notificaciones")
        .hkBackdrop()
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
