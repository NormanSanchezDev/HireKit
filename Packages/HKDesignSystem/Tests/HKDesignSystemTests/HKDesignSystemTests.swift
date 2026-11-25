import Foundation
import HKDesignSystem
import SwiftUI
import Testing

@MainActor
struct HKDesignSystemTests {
    @Test func defaultSelectionFollowsSystem() {
        let manager = HKThemeManager(defaults: nil)
        #expect(manager.selectedMode == .system)
        #expect(manager.selectedMode.colorScheme == nil)
    }

    @Test(arguments: HKThemeMode.allCases)
    func persistsSelection(mode: HKThemeMode) throws {
        let suite = "HKThemeTests." + UUID().uuidString
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }

        let manager = HKThemeManager(defaults: defaults)
        manager.selectedMode = .dark
        manager.selectedMode = mode
        #expect(HKThemeManager(defaults: defaults).selectedMode == mode)
    }

    @Test func colorsAdaptToEachColorScheme() {
        let textPrimary = HKTheme().colors.textPrimary
        var environment = EnvironmentValues()
        environment.colorScheme = .light
        let light = textPrimary.resolve(in: environment)
        environment.colorScheme = .dark
        let dark = textPrimary.resolve(in: environment)
        #expect(light.red < dark.red)
    }

    @Test func environmentProvidesThemeByDefault() {
        let theme = EnvironmentValues().hkTheme
        #expect(theme.spacing.large == HKTheme().spacing.large)
    }

    @Test func semanticPaletteDistinguishesContentAndFeedback() {
        let colors = HKTheme().colors
        let environment = EnvironmentValues()
        #expect(colors.textPrimary.resolve(in: environment) != colors.background.resolve(in: environment))
        #expect(colors.primary.resolve(in: environment) != colors.secondary.resolve(in: environment))
        #expect(colors.success.resolve(in: environment) != colors.error.resolve(in: environment))
        #expect(colors.warning.resolve(in: environment) != colors.error.resolve(in: environment))
    }
}
