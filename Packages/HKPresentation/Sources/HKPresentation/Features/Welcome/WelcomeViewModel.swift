import Foundation
import HKDomain
import Observation

/// The state and actions of the welcome screen.
@MainActor
@Observable
public final class WelcomeViewModel {
    /// A Boolean value that indicates whether progress is being saved.
    public private(set) var isLoading = false

    /// The error to show, if any.
    public private(set) var errorMessage: LocalizedStringResource?

    /// A Boolean value that indicates whether an error alert is showing.
    /// Setting it to `false` clears ``errorMessage``.
    public var isShowingError: Bool {
        get { errorMessage != nil }
        set { if !newValue { errorMessage = nil } }
    }

    private let completeOnboarding: any CompleteOnboardingUseCase
    private let onFinish: @MainActor () -> Void

    /// Creates the ViewModel.
    ///
    /// - Parameters:
    ///   - completeOnboarding: The use case that stores the finished welcome flow.
    ///   - onFinish: Called after progress is saved.
    public init(
        completeOnboarding: any CompleteOnboardingUseCase,
        onFinish: @escaping @MainActor () -> Void
    ) {
        self.completeOnboarding = completeOnboarding
        self.onFinish = onFinish
    }

    /// Finishes the welcome flow and continues to the next one.
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
}
