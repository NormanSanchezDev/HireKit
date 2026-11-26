import HKDesignSystem
import SwiftUI

/// The sign-up introduction, pushed from sign in. It presents the
/// registration stages and starts the registration.
struct SignUpView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled
    @Environment(\.hkTheme) private var theme
    @State private var viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
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
        .onAppear { viewModel.onAppear(allowsAutoAdvance: allowsAutoAdvance) }
        .onDisappear(perform: viewModel.onDisappear)
        .onChange(of: allowsAutoAdvance) { _, allowed in
            viewModel.allowsAutoAdvanceChanged(allowed)
        }
    }

    private var allowsAutoAdvance: Bool {
        !reduceMotion && !voiceOverEnabled
    }

    private func content(_ state: SignUpUIState) -> some View {
        ScrollView {
            VStack(spacing: theme.spacing.extraLarge) {
                HKAnimation(model: state.animation)
                    .frame(width: state.animationSize, height: state.animationSize)
                VStack(alignment: .leading, spacing: theme.spacing.medium) {
                    HKLabel(model: state.titleLabel)
                        .accessibilityAddTraits(.isHeader)
                    HKLabel(model: state.descriptionLabel)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HKStepCarousel(model: state.carousel, onSelect: viewModel.select)
            }
            .padding(theme.spacing.extraLarge)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)
        }
        .safeAreaInset(edge: .bottom) {
            actions(state)
        }
        .navigationTitle(state.navigationTitle)
    }

    private func actions(_ state: SignUpUIState) -> some View {
        HKGlassGroup(spacing: theme.spacing.large) {
            VStack(spacing: theme.spacing.medium) {
                HKButton(model: state.startButton)
                    .keyboardShortcut(.defaultAction)
                HKButton(model: state.signInButton)
            }
        }
        .padding(.horizontal, theme.spacing.extraLarge)
        .padding(.bottom, theme.spacing.large)
        .frame(maxWidth: 520)
    }
}

#if DEBUG
#Preview("Sign up introduction") {
    NavigationStack {
        SignUpView(viewModel: HKPreviewViewModelFactory().makeSignUpViewModel(onStart: {}, onSignIn: {}))
    }
}
#endif
