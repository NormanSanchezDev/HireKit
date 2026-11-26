import Foundation
import HKDomain
import SwiftUI

/// The checks of the personal information step. Name and age rules come from
/// the domain, so the form and the backend agree.
///
/// Names are checked as ``PersonName/cleaned(_:)`` leaves them, so lowercase
/// or extra spaces never block the person.
enum PersonalInformationValidator {
    static func requiredNameError(_ name: String) -> LocalizedStringKey? {
        PersonName.cleaned(name).isEmpty ? "sign_up_name_required_txt" : optionalNameError(name)
    }

    static func optionalNameError(_ name: String) -> LocalizedStringKey? {
        let cleaned = PersonName.cleaned(name)
        return cleaned.isEmpty || PersonName.isValid(cleaned) ? nil : "sign_up_name_invalid_txt"
    }

    static func birthDateError(
        _ birthDate: Date?,
        today: Date,
        calendar: Calendar = .current
    ) -> LocalizedStringKey? {
        guard let birthDate else { return "sign_up_birth_date_invalid_txt" }
        let day = calendar.startOfDay(for: birthDate)
        let allowed = BirthDateRule.allowedRange(today: today, calendar: calendar)
        if day > calendar.startOfDay(for: today) || day < allowed.lowerBound {
            return "sign_up_birth_date_invalid_txt"
        }
        return day > allowed.upperBound ? "sign_up_birth_date_underage_txt" : nil
    }

    static func isValid(_ personal: PersonalInformation, today: Date) -> Bool {
        requiredNameError(personal.firstName) == nil
            && requiredNameError(personal.paternalLastName) == nil
            && optionalNameError(personal.maternalLastName) == nil
            && birthDateError(personal.birthDate, today: today) == nil
    }
}
