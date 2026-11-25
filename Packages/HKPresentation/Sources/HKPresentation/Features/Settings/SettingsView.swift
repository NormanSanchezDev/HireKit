import HKDesignSystem
import SwiftUI

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
                    HKRowLabel(systemImage: "paintpalette") {
                        Text("Apariencia")
                    }
                }
                Button(action: onOpenAbout) {
                    HKRowLabel(systemImage: "info.circle") {
                        Text("Acerca de HireKit")
                    }
                }
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

struct AboutView: View {
    let onClose: () -> Void

    var body: some View {
        ContentUnavailableView(
            "HireKit",
            systemImage: "briefcase.fill",
            description: Text("Tu compañero en cada proceso de contratación.")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Acerca de")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Listo", action: onClose)
            }
        }
        .hkBackdrop()
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
