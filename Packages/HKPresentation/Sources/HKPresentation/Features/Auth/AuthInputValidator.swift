import Foundation
import SwiftUI

/// Form-level checks shown while typing. Real credential checks belong to a
/// domain use case once there is a backend.
enum AuthInputValidator {
    static let minimumPasswordLength = 8

    static func emailError(_ email: String) -> LocalizedStringKey? {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return "auth_email_required_txt" }
        let parts = trimmed.split(separator: "@", omittingEmptySubsequences: false)
        let isValid = parts.count == 2 && !parts[0].isEmpty && parts[1].contains(".")
            && !parts[1].hasPrefix(".") && !parts[1].hasSuffix(".")
        return isValid ? nil : "auth_email_invalid_txt"
    }

    static func passwordError(_ password: String) -> LocalizedStringKey? {
        if password.isEmpty { return "auth_password_required_txt" }
        return password.count < minimumPasswordLength
            ? "auth_password_minimum_\(minimumPasswordLength)_txt"
            : nil
    }

    static func nameError(_ name: String) -> LocalizedStringKey? {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "auth_name_required_txt" : nil
    }
}
