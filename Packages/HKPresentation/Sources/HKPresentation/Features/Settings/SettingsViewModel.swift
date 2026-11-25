import Foundation
import HKDomain
import Observation

@MainActor
@Observable
public final class SettingsViewModel {
    public private(set) var isResetting = false
    public private(set) var errorMessage: LocalizedStringResource?

    private let resetOnboarding: any ResetOnboardingUseCase
    private let onResetOnboarding: @MainActor () -> Void

    public init(
        resetOnboarding: any ResetOnboardingUseCase,
        onResetOnboarding: @escaping @MainActor () -> Void
    ) {
        self.resetOnboarding = resetOnboarding
        self.onResetOnboarding = onResetOnboarding
    }

    public func showWelcomeAgain() async {
        guard !isResetting else { return }
        isResetting = true
        defer { isResetting = false }
        do {
            try await resetOnboarding.execute()
            onResetOnboarding()
        } catch {
            errorMessage = "No pudimos restablecer la bienvenida. Inténtalo de nuevo."
        }
    }

    public func dismissError() {
        errorMessage = nil
    }
}
