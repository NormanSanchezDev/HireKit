import Foundation
import HKData
import HKDomain
import Testing

struct DefaultOnboardingRepositoryTests {
    private func makeDefaults() throws -> (UserDefaults, String) {
        let suite = "HKDataTests." + UUID().uuidString
        return (try #require(UserDefaults(suiteName: suite)), suite)
    }

    @Test func missingValueIsPending() async throws {
        let (defaults, suite) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }
        let repository = DefaultOnboardingRepository(
            localDataSource: UserDefaultsOnboardingDataSource(defaults: defaults)
        )
        #expect(await repository.currentState() == .pending)
    }

    @Test(arguments: OnboardingState.allCases)
    func savedStateSurvivesNewRepository(state: OnboardingState) async throws {
        let (defaults, suite) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }
        let dataSource = UserDefaultsOnboardingDataSource(defaults: defaults)
        try await DefaultOnboardingRepository(localDataSource: dataSource).save(state)
        #expect(await DefaultOnboardingRepository(localDataSource: dataSource).currentState() == state)
    }

    @Test func unknownValueFallsBackToPending() async throws {
        let (defaults, suite) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }
        let dataSource = UserDefaultsOnboardingDataSource(defaults: defaults)
        dataSource.writeState("unexpected")
        #expect(await DefaultOnboardingRepository(localDataSource: dataSource).currentState() == .pending)
    }
}
