import HKDesignSystem
import SwiftUI

/**
 * Main shell. `sidebarAdaptable` gives a floating Liquid Glass tab bar on
 * iPhone and a glass sidebar on iPad and Mac.
 */
struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @State private var settingsViewModel: SettingsViewModel

    init(viewModel: HomeViewModel, settingsViewModel: SettingsViewModel) {
        _viewModel = State(initialValue: viewModel)
        _settingsViewModel = State(initialValue: settingsViewModel)
    }

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            Tab("Inicio", systemImage: "house", value: HomeViewModel.Tab.dashboard) {
                NavigationStack {
                    DashboardView(greeting: viewModel.greeting)
                }
            }
            Tab("Ajustes", systemImage: "gearshape", value: HomeViewModel.Tab.settings) {
                NavigationStack {
                    SettingsView(viewModel: settingsViewModel)
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

private struct DashboardView: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    let greeting: HomeViewModel.Greeting

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
