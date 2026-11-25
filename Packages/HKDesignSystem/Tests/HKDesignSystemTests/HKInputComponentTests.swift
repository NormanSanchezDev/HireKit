import Foundation
import SwiftUI
import Testing
@testable import HKDesignSystem

struct HKInputComponentTests {
    @Test(arguments: [
        ("", ""),
        ("5", "(5"),
        ("56", "(56"),
        ("562", "(56) 2"),
        ("5625", "(56) 25"),
        ("56250", "(56) 25 0"),
        ("5625068370", "(56) 25 06 83 70"),
        ("562506837099", "(56) 25 06 83 70"),
    ])
    func phoneMaskGrowsWithDigits(digits: String, expected: String) {
        #expect(HKPhoneFormat.format(digits) == expected)
    }

    @Test func phoneDigitsIgnoreMaskAndDialCode() {
        #expect(HKPhoneFormat.digits(in: "(56) 25 06 83 70") == "5625068370")
        #expect(HKPhoneFormat.digits(in: "(56) 25 06 83 701") == "5625068370")
        #expect(HKPhoneFormat.digits(in: "+52 56 2506 8370") == "5625068370")
        #expect(HKPhoneFormat.digits(in: "(56") == "56")
    }

    @Test func deletingAMaskCharacterRemovesADigit() {
        let afterBackspace = String(HKPhoneFormat.format("562").dropLast())
        #expect(HKPhoneFormat.format(HKPhoneFormat.digits(in: afterBackspace)) == "(56")
    }

    @Test func datePickerShowsDayMonthYear() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "UTC"))
        let date = try #require(calendar.date(from: DateComponents(year: 1990, month: 3, day: 5)))
        #expect(HKDatePickerModel.text(for: date, calendar: calendar) == "05/03/1990")
    }

    @Test func inputModelsLetErrorsOverrideValidation() {
        let range = Date.distantPast...Date.now
        let date = HKDatePickerModel(title: "Fecha", range: range, errorMessage: "Requerida", validation: .success("Ok"))
        let phone = HKPhoneFieldModel(title: "Teléfono", dialCodes: [HKDropdownOption(value: 1, title: "+1", accessibilityLabel: "EE. UU.")], errorMessage: "Requerido")
        #expect(date.validation == .error("Requerida"))
        #expect(phone.validation == .error("Requerido"))
        #expect(HKFieldModel(title: "Nombre").capitalization == .never)
        #expect(HKFieldModel(title: "Nombre", capitalization: .words).capitalization == .words)
    }
}
