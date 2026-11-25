import HKDesignSystem
import HKPresentation
import SwiftUI

@main
struct HireKitApp: App {
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            HKRootView(factory: dependencies)
                .tint(HKTheme().colors.primary)
                .environment(dependencies.themeManager)
                .preferredColorScheme(dependencies.themeManager.selectedMode.colorScheme)
                #if os(macOS)
                .frame(minWidth: 720, minHeight: 520)
                #endif
        }
        #if os(macOS)
        .defaultSize(width: 1100, height: 720)
        .windowResizability(.contentMinSize)
        .windowToolbarStyle(.unified)
        #endif
    }
}
