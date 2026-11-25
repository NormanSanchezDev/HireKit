import HKDesignSystem
import SwiftUI

/// The theme picker, pushed from settings.
struct AppearanceView: View {
    @Environment(HKThemeManager.self) private var themeManager

    var body: some View {
        @Bindable var themeManager = themeManager
        Form {
            Section("appearance_theme_txt") {
                Picker("appearance_theme_txt", selection: $themeManager.selectedMode) {
                    Text("appearance_system_txt").tag(HKThemeMode.system)
                    Text("appearance_light_txt").tag(HKThemeMode.light)
                    Text("appearance_dark_txt").tag(HKThemeMode.dark)
                }
                .pickerStyle(.segmented)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .navigationTitle("appearance_navigation_title_txt")
        .hkBackground()
    }
}

#if DEBUG
#Preview("Appearance") {
    NavigationStack { AppearanceView() }
        .environment(HKThemeManager(defaults: nil))
}
#endif
