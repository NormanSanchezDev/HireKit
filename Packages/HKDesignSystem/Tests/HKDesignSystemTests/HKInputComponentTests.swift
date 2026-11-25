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

    @Test(arguments: [
        ("", ""),
        ("0", "0"),
        ("04", "04/"),
        ("040", "04/0"),
        ("0406", "04/06/"),
        ("04061", "04/06/1"),
        ("04061994", "04/06/1994"),
        ("040619941", "04/06/1994"),
    ])
    func dateMaskGrowsWithDigits(digits: String, expected: String) {
        #expect(HKDateFormat.format(digits) == expected)
    }

    @Test(arguments: [
        ("04/06/", "04/06", "04/0"),
        ("04/", "04", "0"),
        ("04/06/1", "04/06/", "04/06/"),
        ("04/0", "04/06", "04/06/"),
        ("04/06/1994", "04/06/199", "04/06/199"),
        ("", "04061994", "04/06/1994"),
    ])
    func dateEditsCarryOverSeparators(oldText: String, newText: String, expected: String) {
        #expect(HKDateFormat.edit(from: oldText, to: newText) == expected)
    }

    @Test func dateDigitsParseOnlyRealDays() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "UTC"))
        let date = try #require(HKDateFormat.date(fromDigits: "04061994", calendar: calendar))
        #expect(calendar.dateComponents([.year, .month, .day], from: date) == DateComponents(year: 1994, month: 6, day: 4))
        #expect(HKDateFormat.text(for: date, calendar: calendar) == "04/06/1994")
        #expect(HKDateFormat.date(fromDigits: "31021990", calendar: calendar) == nil)
        #expect(HKDateFormat.date(fromDigits: "00011990", calendar: calendar) == nil)
        #expect(HKDateFormat.date(fromDigits: "0406199", calendar: calendar) == nil)
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
