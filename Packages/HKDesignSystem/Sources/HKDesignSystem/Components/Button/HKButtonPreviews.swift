#if DEBUG
import SwiftUI

private struct ButtonPreview: View {
    @State private var manager: HKThemeManager

    init(_ mode: HKThemeMode) {
        let manager = HKThemeManager(defaults: nil)
        manager.selectedMode = mode
        _manager = State(initialValue: manager)
    }

    var body: some View {
        let spacing = manager.current.spacing
        ScrollView {
            HKGlassGroup(spacing: spacing.medium) {
                VStack(spacing: spacing.large) { controls }
            }
            .padding(spacing.extraLarge)
        }
        .environment(manager)
        .preferredColorScheme(manager.selectedMode.colorScheme)
    }

    @ViewBuilder
    private var controls: some View {
        @Bindable var manager = manager
        Menu {
            Picker("Appearance", selection: $manager.selectedMode) {
                Text("System").tag(HKThemeMode.system)
                Text("Light").tag(HKThemeMode.light)
                Text("Dark").tag(HKThemeMode.dark)
            }
        } label: {
            Label("Appearance", systemImage: "circle.lefthalf.filled")
                .padding(manager.current.spacing.medium)
                .glassEffect(.regular.interactive())
        }
        .menuStyle(.button)
        .buttonStyle(.plain)

        HKButton("Continue") {}
        HKButton("Cancel", variant: .secondary) {}
        HKButton("Saving", isLoading: true) {}
        HKButton("Unavailable") {}
            .disabled(true)
    }
}

#Preview("Light") { ButtonPreview(.light) }
#Preview("Dark") { ButtonPreview(.dark) }
#Preview("System · switch appearance") { ButtonPreview(.system) }
#Preview("Accessibility text") {
    ButtonPreview(.system).environment(\.dynamicTypeSize, .accessibility4)
}
#endif
