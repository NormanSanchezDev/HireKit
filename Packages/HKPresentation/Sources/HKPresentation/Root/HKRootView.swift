import HKDesignSystem
import SwiftUI

/// Entry view of the presentation layer. Receives its factory from the app's
/// composition root and swaps between the welcome, auth and home flows.
public struct HKRootView: View {
    @State private var viewModel: RootViewModel
    private let factory: any HKViewModelFactory

    public init(factory: any HKViewModelFactory) {
        self.factory = factory
        _viewModel = State(initialValue: factory.makeRootViewModel())
    }

    public var body: some View {
        content
            .animation(.smooth, value: viewModel.destination)
            .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.destination {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .hkBackdrop()
        case .welcome:
            WelcomeView(viewModel: factory.makeWelcomeViewModel(onFinish: viewModel.onboardingFinished))
                .transition(.blurReplace)
        case .auth:
            AuthFlowView(factory: factory, onAuthenticated: viewModel.authenticated)
                .transition(.blurReplace)
        case .home:
            HomeView(
                viewModel: factory.makeHomeViewModel(),
                settingsViewModel: factory.makeSettingsViewModel(onResetOnboarding: viewModel.onboardingReset)
            )
            .transition(.blurReplace)
        }
    }
}

#if DEBUG
#Preview("Root") {
    HKRootView(factory: HKPreviewViewModelFactory())
        .environment(HKThemeManager(defaults: nil))
}
#endif
