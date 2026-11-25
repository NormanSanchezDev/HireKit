import HKDesignSystem
import SwiftUI

struct SettingsView: View {
    @Environment(HKThemeManager.self) private var themeManager
    @State private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var themeManager = themeManager
        Form {
            Section("Apariencia") {
                Picker("Tema", selection: $themeManager.selectedMode) {
                    Text("Sistema").tag(HKThemeMode.system)
                    Text("Claro").tag(HKThemeMode.light)
                    Text("Oscuro").tag(HKThemeMode.dark)
                }
                .pickerStyle(.segmented)
            }
            Section("Bienvenida") {
                Button {
                    Task { await viewModel.showWelcomeAgain() }
                } label: {
                    HKRowLabel(systemImage: "sparkles") {
                        Text("Ver la bienvenida de nuevo")
                    }
                }
                .disabled(viewModel.isResetting)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .navigationTitle("Ajustes")
        .hkBackdrop()
        .alert(
            "Algo salió mal",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.dismissError() } }
            ),
            presenting: viewModel.errorMessage
        ) { _ in
            Button("Aceptar", role: .cancel) {}
        } message: { message in
            Text(message)
        }
    }
}

#if DEBUG
#Preview("Settings") {
    NavigationStack {
        SettingsView(viewModel: HKPreviewViewModelFactory().makeSettingsViewModel {})
    }
    .environment(HKThemeManager(defaults: nil))
}
#endif
