import Foundation
import HKDomain
import Testing

struct ProfileRulesTests {
    @Test(arguments: [
        ("CArlos arTURO", "Carlos Arturo"),
        (" Carlos.  Arturo ", "Carlos Arturo"),
        ("maría-josé", "María-José"),
        ("o'brien", "O'brien"),
        ("ana3", "Ana"),
        ("  ", ""),
    ])
    func cleanedNames(input: String, expected: String) {
        #expect(PersonName.cleaned(input) == expected)
    }

    @Test(arguments: ["Ana", "Luz", "Carlos Arturo", "De La Cruz", "O'Brien", "María-José"])
    func validNames(name: String) {
        #expect(PersonName.isValid(name))
    }

    @Test(arguments: ["", "A", "ana", "Carlos  Arturo", " Carlos", "Carlos ", "Carlos arturo", "Ana3"])
    func invalidNames(name: String) {
        #expect(!PersonName.isValid(name))
    }

    @Test func phoneKeepsOnlyTenDigits() throws {
        let phone = try #require(PhoneNumber(dialCode: .mexico, digits: "(56) 25 06 83 70"))
        #expect(phone.nationalNumber == "5625068370")
        #expect(phone.dialCode.rawValue == "+52")
        #expect(PhoneNumber(dialCode: .unitedStates, digits: "562506837") == nil)
        #expect(PhoneNumber(dialCode: .unitedStates, digits: "56250683701") == nil)
    }

    @Test func birthDateRequiresEighteenYears() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "UTC"))
        let today = try #require(calendar.date(from: DateComponents(year: 2026, month: 11, day: 25, hour: 15)))
        let eighteenToday = try #require(calendar.date(from: DateComponents(year: 2008, month: 11, day: 25)))
        let eighteenTomorrow = try #require(calendar.date(from: DateComponents(year: 2008, month: 11, day: 26)))
        #expect(BirthDateRule.isAllowed(eighteenToday, today: today, calendar: calendar))
        #expect(!BirthDateRule.isAllowed(eighteenTomorrow, today: today, calendar: calendar))
        #expect(!BirthDateRule.isAllowed(today, today: today, calendar: calendar))
    }
}
