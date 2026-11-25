/**
 * Domain contract for reading and storing onboarding progress.
 * Implemented in HKData; the domain never knows where data lives.
 */
public protocol OnboardingRepository: Sendable {
    func currentState() async -> OnboardingState
    func save(_ state: OnboardingState) async throws
}
