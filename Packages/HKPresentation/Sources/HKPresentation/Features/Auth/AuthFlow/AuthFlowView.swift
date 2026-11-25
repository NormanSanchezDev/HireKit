import HKDesignSystem
import SwiftUI

/// Coordinator of the authentication flow. Owns its router, builds every
/// screen through the factory and turns ViewModel callbacks into navigation.
/// ViewModels never see the router.
struct AuthFlowView: View {
    @State private var router: HKRouter<AuthRoute>
    private let factory: any HKViewModelFactory
    private let onAuthenticated: @MainActor () -> Void

    init(
        factory: any HKViewModelFactory,
        router: HKRouter<AuthRoute> = HKRouter(),
        onAuthenticated: @escaping @MainActor () -> Void
    ) {
        self.factory = factory
        self.onAuthenticated = onAuthenticated
        _router = State(initialValue: router)
    }

    var body: some View {
        HKRouterStack(router: router) {
            screen(for: .signIn)
        } destination: { route in
            screen(for: route)
        }
    }

    @ViewBuilder
    private func screen(for route: AuthRoute) -> some View {
        switch route {
        case .signIn:
            SignInView(viewModel: factory.makeSignInViewModel(
                onSignUp: { [router] in router.push(.signUp) },
                onAuthenticated: onAuthenticated
            ))
        case .signUp:
            SignUpView(viewModel: factory.makeSignUpViewModel(
                onAuthenticated: onAuthenticated,
                onConfirmationRequired: { [router] in router.popToRoot() }
            ))
        }
    }
}

#if DEBUG
#Preview("Auth flow") {
    AuthFlowView(factory: HKPreviewViewModelFactory()) {}
        .environment(HKThemeManager(defaults: nil))
}
#endif
