import Foundation
import HKPresentation
import Testing
@testable import HireKit

@MainActor
struct AppDependenciesTests {
    private func makeDefaults() throws -> (UserDefaults, String) {
        let suite = "HireKitTests." + UUID().uuidString
        return (try #require(UserDefaults(suiteName: suite)), suite)
    }

    @Test func freshInstallStartsOnWelcome() async throws {
        let (defaults, suite) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }
        let root = AppDependencies(defaults: defaults).makeRootViewModel()
        await root.load()
        #expect(root.destination == .welcome)
    }

    @Test func finishingWelcomePersistsAcrossLaunches() async throws {
        let (defaults, suite) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }
        let dependencies = AppDependencies(defaults: defaults)
        let root = dependencies.makeRootViewModel()
        await root.load()
        await dependencies.makeWelcomeViewModel(onFinish: root.onboardingFinished).start()
        #expect(root.destination == .auth)

        let relaunched = AppDependencies(defaults: defaults).makeRootViewModel()
        await relaunched.load()
        #expect(relaunched.destination == .home)
    }

    @Test func settingsResetBringsWelcomeBack() async throws {
        let (defaults, suite) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }
        let dependencies = AppDependencies(defaults: defaults)
        let root = dependencies.makeRootViewModel()
        await dependencies.makeWelcomeViewModel(onFinish: root.onboardingFinished).start()
        await dependencies.makeSettingsViewModel(onResetOnboarding: root.onboardingReset).showWelcomeAgain()
        #expect(root.destination == .welcome)
    }

    @Test func themeManagerIsShared() throws {
        let (defaults, suite) = try makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }
        let dependencies = AppDependencies(defaults: defaults)
        #expect(dependencies.themeManager === dependencies.themeManager)
    }
}
