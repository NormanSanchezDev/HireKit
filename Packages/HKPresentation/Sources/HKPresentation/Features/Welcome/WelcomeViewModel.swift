import Foundation
import SwiftUI
import HKDomain
import Observation

/// The state and actions of the welcome screen.
@MainActor
@Observable
public final class WelcomeViewModel {
    /// The screen state prepared on first appearance.
    public private(set) var uiState: WelcomeUIState?

    /// A Boolean value that indicates whether progress is being saved.
    public var isLoading: Bool { uiState?.isLoading == true }

    /// The error to show, if any.
    public var errorMessage: LocalizedStringKey? { uiState?.errorMessage }

    /// A Boolean value that indicates whether an error alert is showing.
    /// Setting it to `false` clears ``errorMessage``.
    public var isShowingError: Bool {
        get { errorMessage != nil }
        set { if !newValue { uiState?.errorMessage = nil } }
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

    /// Prepares the screen once, preserving in-flight work on subsequent appearances.
    public func onAppear() {
        guard uiState == nil else { return }
        uiState = WelcomeUIState { [weak self] in
            Task { await self?.start() }
        }
    }

    /// Finishes the welcome flow and continues to the next one.
    public func start() async {
        onAppear()
        guard !isLoading else { return }
        uiState?.errorMessage = nil
        uiState?.isLoading = true
        defer { uiState?.isLoading = false }
        do {
            try await completeOnboarding.execute()
            onFinish()
        } catch {
            uiState?.errorMessage = "welcome_save_error_txt"
        }
    }
}
