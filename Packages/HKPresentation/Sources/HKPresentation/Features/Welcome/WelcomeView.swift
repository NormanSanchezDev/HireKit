import HKDesignSystem
import SwiftUI

struct WelcomeView: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel: WelcomeViewModel

    init(viewModel: WelcomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        let theme = themeManager.current(for: colorScheme)
        VStack(spacing: theme.spacing.extraLarge) {
            Spacer(minLength: 0)
            
            HKImage(.media("hk_placeholder"))
                .padding(theme.spacing.extraLarge)
                .accessibilityHidden(true)

            HKGlassCard {
                VStack(alignment: .leading, spacing: theme.spacing.medium) {
                    HKLabel(model: .init(text: "Bienvenido a HireKit", type: .title, tone: .accent))
                        .accessibilityAddTraits(.isHeader)
                    HKLabel(model: .init(text: "La aplicación que te ayudará en tu proceso de contratación"))
                    HKLabel(model: .init(text: "Are you ready?", type: .subheadline))
                }
            }
            Spacer(minLength: 0)

            HKButton("Let's go", isLoading: viewModel.isLoading) {
                Task { await viewModel.start() }
            }
            .frame(maxWidth: .infinity)
            .keyboardShortcut(.defaultAction)
        }
        .padding(theme.spacing.extraLarge)
        .frame(maxWidth: 560)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
#Preview("Welcome") {
    WelcomeView(viewModel: HKPreviewViewModelFactory().makeWelcomeViewModel {})
        .environment(HKThemeManager(defaults: nil))
}
#endif
