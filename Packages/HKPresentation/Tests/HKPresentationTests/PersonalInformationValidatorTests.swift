import Foundation
import HKDomain
@testable import HKPresentation
import SwiftUI
import Testing

struct PersonalInformationValidatorTests {
    private let calendar = Calendar(identifier: .gregorian)

    private func date(yearsBefore years: Int, days: Int = 0) -> Date {
        let shifted = calendar.date(byAdding: .year, value: -years, to: SignUpFixtures.today) ?? SignUpFixtures.today
        return calendar.date(byAdding: .day, value: days, to: shifted) ?? shifted
    }

    @Test func requiredNamesRejectEmptyAndAcceptCompoundAccentedNames() {
        #expect(PersonalInformationValidator.requiredNameError("") == "sign_up_name_required_txt")
        #expect(PersonalInformationValidator.requiredNameError("   ") == "sign_up_name_required_txt")
        #expect(PersonalInformationValidator.requiredNameError("a") == "sign_up_name_invalid_txt")
        #expect(PersonalInformationValidator.requiredNameError("José María") == nil)
        #expect(PersonalInformationValidator.requiredNameError("núñez") == nil)
    }

    @Test func maternalSurnameIsOptional() {
        #expect(PersonalInformationValidator.optionalNameError("") == nil)
        #expect(PersonalInformationValidator.optionalNameError("de la Cruz") == nil)
        #expect(PersonalInformationValidator.optionalNameError("a") == "sign_up_name_invalid_txt")
    }

    @Test func birthDateRules() {
        let today = SignUpFixtures.today
        #expect(PersonalInformationValidator.birthDateError(nil, today: today, calendar: calendar) == "sign_up_birth_date_invalid_txt")
        #expect(
            PersonalInformationValidator.birthDateError(date(yearsBefore: 0, days: 3), today: today, calendar: calendar)
                == "sign_up_birth_date_invalid_txt"
        )
        #expect(
            PersonalInformationValidator.birthDateError(date(yearsBefore: 10), today: today, calendar: calendar)
                == "sign_up_birth_date_underage_txt"
        )
        #expect(
            PersonalInformationValidator.birthDateError(date(yearsBefore: 130), today: today, calendar: calendar)
                == "sign_up_birth_date_invalid_txt"
        )
        #expect(PersonalInformationValidator.birthDateError(date(yearsBefore: 30), today: today, calendar: calendar) == nil)
    }

    @Test func wholeStepIsValidOnlyWithEveryRequiredValue() {
        var personal = SignUpFixtures.personal
        #expect(PersonalInformationValidator.isValid(personal, today: SignUpFixtures.today))
        personal.paternalLastName = ""
        #expect(!PersonalInformationValidator.isValid(personal, today: SignUpFixtures.today))
    }
}
