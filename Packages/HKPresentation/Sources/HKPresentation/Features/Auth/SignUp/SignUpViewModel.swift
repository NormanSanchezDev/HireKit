import Foundation
import Observation

/// The state and actions of the sign-up introduction.
///
/// The ViewModel prepares ``SignUpUIState``, advances the carousel of
/// registration stages on a timer, restarts the timer when the person picks a
/// stage, and reports navigation once through callbacks.
@MainActor
@Observable
public final class SignUpViewModel {
    /// The screen state, created by ``onAppear(allowsAutoAdvance:)``.
    public private(set) var uiState: SignUpUIState?

    private let autoAdvanceInterval: Duration
    private let sleep: @Sendable (Duration) async throws -> Void
    private let onStart: @MainActor () -> Void
    private let onSignIn: @MainActor () -> Void
    private var autoAdvanceTask: Task<Void, Never>?
    private var hasRequestedNavigation = false

    /// Creates the ViewModel.
    ///
    /// - Parameters:
    ///   - autoAdvanceInterval: How long each stage stays on screen.
    ///   - sleep: Waits for a duration. Tests replace it to control time.
    ///   - onStart: Called when the person starts the registration.
    ///   - onSignIn: Called when the person already has an account.
    public init(
        autoAdvanceInterval: Duration = .seconds(4),
        sleep: @escaping @Sendable (Duration) async throws -> Void = { try await Task.sleep(for: $0) },
        onStart: @escaping @MainActor () -> Void,
        onSignIn: @escaping @MainActor () -> Void
    ) {
        self.autoAdvanceInterval = autoAdvanceInterval
        self.sleep = sleep
        self.onStart = onStart
        self.onSignIn = onSignIn
    }

    /// Prepares the screen on first appearance and starts the carousel timer.
    ///
    /// Later appearances keep the selected stage and allow navigation again.
    ///
    /// - Parameter allowsAutoAdvance: Whether the carousel may advance on its
    ///   own. The view passes `false` when Reduce Motion or VoiceOver is on.
    public func onAppear(allowsAutoAdvance: Bool) {
        hasRequestedNavigation = false
        if uiState == nil {
            uiState = SignUpUIState(
                onStart: { [weak self] in self?.start() },
                onSignIn: { [weak self] in self?.signIn() }
            )
        }
        allowsAutoAdvanceChanged(allowsAutoAdvance)
    }

    /// Stops the carousel timer while the screen is hidden.
    public func onDisappear() {
        autoAdvanceTask?.cancel()
        autoAdvanceTask = nil
    }

    /// Turns the automatic advance off or on when the accessibility settings
    /// change.
    ///
    /// - Parameter allowed: Whether the carousel may advance on its own.
    public func allowsAutoAdvanceChanged(_ allowed: Bool) {
        uiState?.isAutoAdvanceEnabled = allowed
        restartAutoAdvance()
    }

    /// Shows the stage the person picked and restarts the timer.
    ///
    /// - Parameter index: The position of the stage.
    public func select(_ index: Int) {
        guard let state = uiState, state.steps.indices.contains(index) else { return }
        uiState?.selectedStep = index
        restartAutoAdvance()
    }

    /// Starts the registration. Repeated calls navigate only once.
    public func start() {
        guard requestNavigation() else { return }
        onStart()
    }

    /// Returns to sign in. Repeated calls navigate only once.
    public func signIn() {
        guard requestNavigation() else { return }
        onSignIn()
    }

    private func requestNavigation() -> Bool {
        guard uiState != nil, !hasRequestedNavigation else { return false }
        hasRequestedNavigation = true
        onDisappear()
        return true
    }

    private func restartAutoAdvance() {
        autoAdvanceTask?.cancel()
        autoAdvanceTask = nil
        guard uiState?.isAutoAdvanceEnabled == true else { return }
        let interval = autoAdvanceInterval
        let sleep = sleep
        autoAdvanceTask = Task { [weak self] in
            while !Task.isCancelled {
                do {
                    try await sleep(interval)
                } catch {
                    return
                }
                guard !Task.isCancelled else { return }
                self?.advance()
            }
        }
    }

    private func advance() {
        guard let state = uiState else { return }
        uiState?.selectedStep = (state.selectedStep + 1) % state.steps.count
    }
}
