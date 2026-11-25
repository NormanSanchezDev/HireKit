import Foundation
import SwiftUI
import HKDomain
import Observation

/// The state and actions of the settings tab.
@MainActor
@Observable
public final class SettingsViewModel {
    /// A Boolean value that indicates whether the welcome flow is being reset.
    public private(set) var isResetting = false

    /// The error to show, if any.
    public private(set) var errorMessage: LocalizedStringKey?

    /// A Boolean value that indicates whether an error alert is showing.
    /// Setting it to `false` clears ``errorMessage``.
    public var isShowingError: Bool {
        get { errorMessage != nil }
        set { if !newValue { errorMessage = nil } }
    }

    private let resetOnboarding: any ResetOnboardingUseCase
    private let onResetOnboarding: @MainActor () -> Void

    /// Creates the ViewModel.
    ///
    /// - Parameters:
    ///   - resetOnboarding: The use case that brings the welcome flow back.
    ///   - onResetOnboarding: Called after the reset succeeds.
    public init(
        resetOnboarding: any ResetOnboardingUseCase,
        onResetOnboarding: @escaping @MainActor () -> Void
    ) {
        self.resetOnboarding = resetOnboarding
        self.onResetOnboarding = onResetOnboarding
    }

    /// Resets the welcome flow so the app shows it again.
    public func showWelcomeAgain() async {
        guard !isResetting else { return }
        isResetting = true
        defer { isResetting = false }
        do {
            try await resetOnboarding.execute()
            onResetOnboarding()
        } catch {
            errorMessage = "settings_reset_error_txt"
        }
    }
}
