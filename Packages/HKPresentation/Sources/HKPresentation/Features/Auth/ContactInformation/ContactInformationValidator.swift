import HKDomain
import SwiftUI

/// The checks of the contact information step. Email and password rules are
/// shared with sign in through ``AuthInputValidator``.
enum ContactInformationValidator {
    static func emailError(_ email: String) -> LocalizedStringKey? {
        AuthInputValidator.emailError(email)
    }

    static func phoneError(_ digits: String) -> LocalizedStringKey? {
        if digits.isEmpty { return "sign_up_phone_required_txt" }
        return digits.count == PhoneNumber.digitCount ? nil : "sign_up_phone_invalid_txt"
    }

    static func passwordError(_ password: String) -> LocalizedStringKey? {
        AuthInputValidator.passwordError(password)
    }
}
