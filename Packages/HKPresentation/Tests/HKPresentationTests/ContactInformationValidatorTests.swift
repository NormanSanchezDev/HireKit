@testable import HKPresentation
import SwiftUI
import Testing

struct ContactInformationValidatorTests {
    @Test func emailRules() {
        #expect(ContactInformationValidator.emailError("") == "auth_email_required_txt")
        #expect(ContactInformationValidator.emailError("ana@") == "auth_email_invalid_txt")
        #expect(ContactInformationValidator.emailError("ana@hirekit") == "auth_email_invalid_txt")
        #expect(ContactInformationValidator.emailError(" ana@hirekit.app ") == nil)
    }

    @Test func phoneNeedsExactlyTenDigits() {
        #expect(ContactInformationValidator.phoneError("") == "sign_up_phone_required_txt")
        #expect(ContactInformationValidator.phoneError("56250") == "sign_up_phone_invalid_txt")
        #expect(ContactInformationValidator.phoneError("562506837012") == "sign_up_phone_invalid_txt")
        #expect(ContactInformationValidator.phoneError(SignUpFixtures.phoneDigits) == nil)
    }

    @Test func passwordNeedsEightCharacters() {
        #expect(ContactInformationValidator.passwordError("") == "auth_password_required_txt")
        #expect(ContactInformationValidator.passwordError("1234567") != nil)
        #expect(ContactInformationValidator.passwordError("12345678") == nil)
    }
}
