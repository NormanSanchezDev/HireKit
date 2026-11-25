import HKDesignSystem
import SwiftUI

/// The root screen of the settings tab.
struct SettingsView: View {
    @State private var viewModel: SettingsViewModel
    private let onOpenAppearance: () -> Void
    private let onOpenAbout: () -> Void

    init(
        viewModel: SettingsViewModel,
        onOpenAppearance: @escaping () -> Void,
        onOpenAbout: @escaping () -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onOpenAppearance = onOpenAppearance
        self.onOpenAbout = onOpenAbout
    }

    var body: some View {
        Form {
            Section {
                Button(action: onOpenAppearance) {
                    HKRowLabel("Apariencia", systemImage: "paintpalette")
                }
                Button(action: onOpenAbout) {
                    HKRowLabel("Acerca de HireKit", systemImage: "info.circle")
                }
            }

            Section("Bienvenida") {
                Button {
                    Task { await viewModel.showWelcomeAgain() }
                } label: {
                    HKRowLabel("Ver la bienvenida de nuevo", systemImage: "sparkles")
                }
                .disabled(viewModel.isResetting)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .navigationTitle("Ajustes")
        .hkBackground()
        .alert("Algo salió mal", isPresented: $viewModel.isShowingError, presenting: viewModel.errorMessage) { _ in
            Button("Aceptar", role: .cancel) {}
        } message: { message in
            Text(message)
        }
    }
}

#if DEBUG
#Preview("Settings") {
    NavigationStack {
        SettingsView(
            viewModel: HKPreviewViewModelFactory().makeSettingsViewModel {},
            onOpenAppearance: {},
            onOpenAbout: {}
        )
    }
    .environment(HKThemeManager(defaults: nil))
}
#endif
