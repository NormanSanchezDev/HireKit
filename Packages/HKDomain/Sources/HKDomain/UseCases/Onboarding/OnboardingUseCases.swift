/// Reads whether the welcome flow is still pending.
public protocol GetOnboardingStateUseCase: Sendable {
    func execute() async -> OnboardingState
}

/// Marks the welcome flow as finished.
public protocol CompleteOnboardingUseCase: Sendable {
    func execute() async throws
}

/// Brings the welcome flow back, for example from Settings.
public protocol ResetOnboardingUseCase: Sendable {
    func execute() async throws
}

public struct DefaultGetOnboardingStateUseCase: GetOnboardingStateUseCase {
    private let repository: any OnboardingRepository

    public init(repository: any OnboardingRepository) {
        self.repository = repository
    }

    public func execute() async -> OnboardingState {
        await repository.currentState()
    }
}

public struct DefaultCompleteOnboardingUseCase: CompleteOnboardingUseCase {
    private let repository: any OnboardingRepository

    public init(repository: any OnboardingRepository) {
        self.repository = repository
    }

    public func execute() async throws {
        try await repository.save(.completed)
    }
}

public struct DefaultResetOnboardingUseCase: ResetOnboardingUseCase {
    private let repository: any OnboardingRepository

    public init(repository: any OnboardingRepository) {
        self.repository = repository
    }

    public func execute() async throws {
        try await repository.save(.pending)
    }
}
