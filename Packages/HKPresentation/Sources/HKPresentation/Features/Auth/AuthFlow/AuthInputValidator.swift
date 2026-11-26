import Foundation
import SwiftUI

/// Credential checks shared by sign in and the contact step of sign-up.
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
}
