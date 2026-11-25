import Foundation
import HKDomain
import SwiftUI

/// Form-level checks of the auth screens. Name, age and phone rules come from
/// the domain, so the form and the backend agree.
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

    static func requiredNameError(_ name: String) -> LocalizedStringKey? {
        name.isEmpty ? "sign_up_name_required_txt" : optionalNameError(name)
    }

    static func optionalNameError(_ name: String) -> LocalizedStringKey? {
        name.isEmpty || PersonName.isValid(name) ? nil : "sign_up_name_invalid_txt"
    }

    static func birthDateError(_ birthDate: Date?, today: Date) -> LocalizedStringKey? {
        guard let birthDate else { return "sign_up_birth_date_invalid_txt" }
        if BirthDateRule.isAllowed(birthDate, today: today) { return nil }
        return birthDate > BirthDateRule.allowedRange(today: today).upperBound
            ? "sign_up_birth_date_underage_txt"
            : "sign_up_birth_date_invalid_txt"
    }

    static func phoneError(_ digits: String) -> LocalizedStringKey? {
        if digits.isEmpty { return "sign_up_phone_required_txt" }
        return digits.count == PhoneNumber.digitCount ? nil : "sign_up_phone_invalid_txt"
    }
}
