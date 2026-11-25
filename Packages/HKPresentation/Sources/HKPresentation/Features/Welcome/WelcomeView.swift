import HKDesignSystem
import SwiftUI

/// The first screen a new user sees.
struct WelcomeView: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel: WelcomeViewModel

    init(viewModel: WelcomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            if let state = viewModel.uiState {
                content(state)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .hkBackground()
        .onAppear(perform: viewModel.onAppear)
    }

    private func content(_ state: WelcomeUIState) -> some View {
        let theme = themeManager.current(for: colorScheme)
        return VStack(spacing: theme.spacing.extraLarge) {
            Spacer(minLength: 0)
            HKImage(
                .media(state.imageResourceName)
            )
            .frame(width: state.imageSize, height: state.imageSize)
            .padding(theme.spacing.extraLarge)

            HKGlassCard {
                VStack(alignment: .leading, spacing: theme.spacing.medium) {
                    HKLabel(state.title, type: .title, tone: .accent)
                        .accessibilityAddTraits(.isHeader)
                    HKLabel(state.description)
                    HKLabel(state.prompt, type: .subheadline, tone: .secondary)
                }
            }
            .frame(maxWidth: 420)
            HKButton(model: state.startButton)
                .keyboardShortcut(.defaultAction)
                .frame(maxWidth: 420)
            Spacer()
        }
        .padding(theme.spacing.extraLarge)
        .alert(state.errorTitle, isPresented: $viewModel.isShowingError, presenting: state.errorMessage) { _ in
            Button(state.dismissTitle, role: .cancel) {}
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
