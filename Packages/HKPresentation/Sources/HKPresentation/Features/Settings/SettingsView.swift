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
                    HKRowLabel("settings_appearance_row_txt", systemImage: "paintpalette")
                }
                Button(action: onOpenAbout) {
                    HKRowLabel("settings_about_row_txt", systemImage: "info.circle")
                }
            }

            Section("settings_welcome_section_txt") {
                Button {
                    Task { await viewModel.showWelcomeAgain() }
                } label: {
                    HKRowLabel("settings_show_welcome_button_txt", systemImage: "sparkles")
                }
                .disabled(viewModel.isResetting)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .navigationTitle("settings_navigation_title_txt")
        .hkBackground()
        .alert("common_error_title", isPresented: $viewModel.isShowingError, presenting: viewModel.errorMessage) { _ in
            Button("common_ok", role: .cancel) {}
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
