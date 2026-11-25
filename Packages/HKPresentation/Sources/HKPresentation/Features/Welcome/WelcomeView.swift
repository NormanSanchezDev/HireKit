import HKDesignSystem
import SwiftUI

/// The first screen a new user sees.
struct WelcomeView: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel: WelcomeViewModel

    private let imageSize: CGFloat = 300

    init(viewModel: WelcomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        let theme = themeManager.current(for: colorScheme)
        VStack(spacing: theme.spacing.extraLarge) {
            Spacer(minLength: 0)
            HKImage(
                .media("hk_programmer_memoji")
            )
            .frame(width: imageSize, height: imageSize)
            .padding(theme.spacing.extraLarge)

            HKGlassCard {
                VStack(alignment: .leading, spacing: theme.spacing.medium) {
                    HKLabel("Bienvenido a HireKit", type: .title, tone: .accent)
                        .accessibilityAddTraits(.isHeader)
                    HKLabel("La aplicación que te ayudará en tu proceso de contratación.")
                    HKLabel("¿Listo para empezar?", type: .subheadline, tone: .secondary)
                }
            }
            Spacer(minLength: 0)
            HKButton(model: .init(title: "Empecemos", isLoading: viewModel.isLoading) {
                Task { await viewModel.start() }
            })
            .frame(maxWidth: .infinity)
            .keyboardShortcut(.defaultAction)
        }
        .padding(theme.spacing.extraLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .hkBackground()
        .alert("Algo salió mal", isPresented: $viewModel.isShowingError, presenting: viewModel.errorMessage) { _ in
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
