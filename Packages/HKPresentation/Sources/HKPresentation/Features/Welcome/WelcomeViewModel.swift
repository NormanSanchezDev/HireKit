import Foundation
import HKDomain
import Observation

@MainActor
@Observable
public final class WelcomeViewModel {
    public private(set) var isLoading = false
    public private(set) var errorMessage: LocalizedStringResource?

    private let completeOnboarding: any CompleteOnboardingUseCase
    private let onFinish: @MainActor () -> Void

    public init(
        completeOnboarding: any CompleteOnboardingUseCase,
        onFinish: @escaping @MainActor () -> Void
    ) {
        self.completeOnboarding = completeOnboarding
        self.onFinish = onFinish
    }

    public func start() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            try await completeOnboarding.execute()
            onFinish()
        } catch {
            errorMessage = "No pudimos guardar tu progreso. Inténtalo de nuevo."
        }
    }

    public func dismissError() {
        errorMessage = nil
    }
}
