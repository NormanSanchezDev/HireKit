import Foundation
import HireKitDesignSystem
import SwiftUI
import Testing

@MainActor
struct HireKitDesignSystemTests {
    @Test func defaultSelectionFollowsSystem() {
        let manager = HKThemeManager(defaults: nil)
        #expect(manager.selectedMode == .system)
        #expect(manager.selectedMode.colorScheme == nil)
    }

    @Test(arguments: HKThemeMode.allCases)
    func persistsSelection(mode: HKThemeMode) throws {
        let suite = "HireKitThemeTests." + UUID().uuidString
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }

        let manager = HKThemeManager(defaults: defaults)
        manager.selectedMode = .dark
        manager.selectedMode = mode
        #expect(HKThemeManager(defaults: defaults).selectedMode == mode)
    }

    @Test func switchingModesUpdatesSemanticTokens() {
        let manager = HKThemeManager(defaults: nil)
        let environment = EnvironmentValues()
        manager.selectedMode = .light
        let light = manager.current(for: .dark).colors.textPrimary.resolve(in: environment)
        manager.selectedMode = .dark
        let dark = manager.current(for: .light).colors.textPrimary.resolve(in: environment)
        #expect(light.red < dark.red)
        #expect(manager.current.colors.textPrimary.resolve(in: environment) == dark)
    }

    @Test func systemTokensFollowEachEnvironment() {
        let manager = HKThemeManager(defaults: nil)
        var environment = EnvironmentValues()
        let adaptive = manager.current.colors.textPrimary
        environment.colorScheme = .light
        let light = adaptive.resolve(in: environment)
        environment.colorScheme = .dark
        let dark = adaptive.resolve(in: environment)
        #expect(light != dark)
        #expect(manager.current(for: .light).colors.textPrimary.resolve(in: environment) == light)
        #expect(manager.current(for: .dark).colors.textPrimary.resolve(in: environment) == dark)
    }

    @Test func semanticPaletteDistinguishesContentAndFeedback() {
        let colors = HKThemeManager(defaults: nil).current(for: .light).colors
        let environment = EnvironmentValues()
        #expect(colors.textPrimary.resolve(in: environment) != colors.background.resolve(in: environment))
        #expect(colors.primary.resolve(in: environment) != colors.secondary.resolve(in: environment))
        #expect(colors.success.resolve(in: environment) != colors.error.resolve(in: environment))
        #expect(colors.warning.resolve(in: environment) != colors.error.resolve(in: environment))
    }
}
