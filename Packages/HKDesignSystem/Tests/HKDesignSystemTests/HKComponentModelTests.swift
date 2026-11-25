import SwiftUI
import Testing
@testable import HKDesignSystem

struct HKComponentModelTests {
    @Test func buttonDefaultsToAnEnabledFilledAction() {
        var didActivate = false
        let model = HKButtonModel(title: "Continuar") { didActivate = true }

        #expect(model.type == .filled)
        #expect(model.systemImage == nil)
        #expect(model.isEnabled)
        #expect(!model.isLoading)
        #expect(!didActivate)
        model.action()
        #expect(didActivate)
    }

    @Test func glassStylesAreDistinct() {
        #expect(HKGlassStyle.regular != .clear)
        #expect(HKGlassStyle.tinted(.indigo) == .tinted(.indigo))
        #expect(HKGlassStyle.tinted(.indigo) != .tinted(.teal))
    }

    @Test func errorMessageOverridesValidation() {
        let model = HKFieldModel(title: "Correo", errorMessage: "Ingresa tu correo.", validation: .success("Ok"))
        #expect(model.validation == .error("Ingresa tu correo."))
        #expect(model.errorMessage == "Ingresa tu correo.")
    }

    @Test func fieldWithoutErrorKeepsValidation() {
        let model = HKFieldModel(title: "Correo", validation: .warning("Revisa el dominio."))
        #expect(model.errorMessage == nil)
        #expect(model.validation == .warning("Revisa el dominio."))
    }

    @Test func labelDefaultsToBodyPrimary() {
        let model = HKLabelModel(text: "Hola")
        #expect(model.type == .body)
        #expect(model.tone == .primary)
    }

    @Test func progressDefaultsToZeroIndeterminatePrimary() {
        let model = HKProgressModel()
        #expect(model.progress == 0)
        #expect(model.type == .indeterminate)
        #expect(model.tone == .primary)
        #expect(model.label == nil)
    }

    @Test func progressClampsOutOfRangeValues() {
        #expect(HKProgressModel(progress: -0.5, type: .linear).progress == 0)
        #expect(HKProgressModel(progress: 1.5, type: .circular).progress == 1)
        #expect(HKProgressModel(progress: 0.42, type: .linear).progress == 0.42)
    }

    @Test @MainActor func progressToneResolvesSemanticPalette() {
        let colors = HKThemeManager(defaults: nil).current(for: .light).colors
        let environment = EnvironmentValues()
        #expect(HKProgressTone.primary.color(in: colors).resolve(in: environment) == colors.primary.resolve(in: environment))
        #expect(HKProgressTone.secondary.color(in: colors).resolve(in: environment) == colors.secondary.resolve(in: environment))
        #expect(HKProgressTone.success.color(in: colors).resolve(in: environment) == colors.success.resolve(in: environment))
        #expect(HKProgressTone.warning.color(in: colors).resolve(in: environment) == colors.warning.resolve(in: environment))
        #expect(HKProgressTone.error.color(in: colors).resolve(in: environment) == colors.error.resolve(in: environment))
    }
}
