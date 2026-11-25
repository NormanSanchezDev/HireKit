import HKDesignSystem
import SwiftUI

/// The root screen of the dashboard tab: a greeting and the active hiring
/// processes.
struct DashboardView: View {
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
                            HKLabel(greetingText, type: .title)
                            HKLabel("Este es el resumen de tu búsqueda.", type: .subheadline)
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

#if DEBUG
#Preview("Dashboard") {
    NavigationStack {
        DashboardView(greeting: .morning) {}
    }
    .environment(HKThemeManager(defaults: nil))
}
#endif
