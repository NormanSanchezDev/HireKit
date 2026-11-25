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
                            HKLabel("dashboard_summary_txt", type: .subheadline)
                        }
                    }
                    HKGlassCard {
                        ContentUnavailableView(
                            "dashboard_empty_title_txt",
                            systemImage: "tray",
                            description: Text("dashboard_empty_description_txt")
                        )
                    }
                }
            }
            .padding(spacing.extraLarge)
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("dashboard_navigation_title_txt")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("dashboard_notifications_button_txt", systemImage: "bell", action: onOpenNotifications)
            }
        }
        .hkBackground()
    }

    private var greetingText: LocalizedStringKey {
        switch greeting {
        case .morning: "dashboard_morning_greeting_txt"
        case .afternoon: "dashboard_afternoon_greeting_txt"
        case .evening: "dashboard_evening_greeting_txt"
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
