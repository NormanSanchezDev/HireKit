import HKDesignSystem
import SwiftUI

/// The theme picker, pushed from settings.
struct AppearanceView: View {
    @Environment(HKThemeManager.self) private var themeManager

    var body: some View {
        @Bindable var themeManager = themeManager
        Form {
            Section("Tema") {
                Picker("Tema", selection: $themeManager.selectedMode) {
                    Text("Sistema").tag(HKThemeMode.system)
                    Text("Claro").tag(HKThemeMode.light)
                    Text("Oscuro").tag(HKThemeMode.dark)
                }
                .pickerStyle(.segmented)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .navigationTitle("Apariencia")
        .hkBackdrop()
    }
}

#if DEBUG
#Preview("Appearance") {
    NavigationStack { AppearanceView() }
        .environment(HKThemeManager(defaults: nil))
}
#endif
