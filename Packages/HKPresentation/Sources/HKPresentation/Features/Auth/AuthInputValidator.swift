import Foundation

/**
 * Form-level checks shown while typing. Real credential checks belong to a
 * domain use case once there is a backend.
 */
enum AuthInputValidator {
    static let minimumPasswordLength = 8

    static func emailError(_ email: String) -> String? {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return "Ingresa tu correo." }
        let parts = trimmed.split(separator: "@", omittingEmptySubsequences: false)
        let isValid = parts.count == 2 && !parts[0].isEmpty && parts[1].contains(".")
            && !parts[1].hasPrefix(".") && !parts[1].hasSuffix(".")
        return isValid ? nil : "Ingresa un correo válido."
    }

    static func passwordError(_ password: String) -> String? {
        if password.isEmpty { return "Ingresa tu contraseña." }
        return password.count < minimumPasswordLength
            ? "Usa al menos \(minimumPasswordLength) caracteres."
            : nil
    }

    static func nameError(_ name: String) -> String? {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Ingresa tu nombre." : nil
    }
}
