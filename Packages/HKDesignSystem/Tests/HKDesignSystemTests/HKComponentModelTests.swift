import SwiftUI
import Testing
@testable import HKDesignSystem

struct HKComponentModelTests {
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
}
