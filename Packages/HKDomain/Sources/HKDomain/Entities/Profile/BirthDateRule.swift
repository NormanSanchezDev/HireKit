import Foundation

/// The rule for an account holder's date of birth.
///
/// A person must be at least ``minimumAge`` years old, and no one is older
/// than ``maximumAge``. Use ``allowedRange(today:calendar:)`` to limit a date
/// picker and ``isAllowed(_:today:calendar:)`` to validate a date.
public enum BirthDateRule {
    /// The youngest age that can create an account.
    public static let minimumAge = 18

    /// The oldest age a date picker offers.
    public static let maximumAge = 120

    /// Returns the dates of birth that are allowed on a given day.
    ///
    /// - Parameters:
    ///   - today: The current date.
    ///   - calendar: The calendar that counts years.
    /// - Returns: The range from ``maximumAge`` to ``minimumAge`` years ago.
    public static func allowedRange(today: Date = .now, calendar: Calendar = .current) -> ClosedRange<Date> {
        let start = calendar.startOfDay(for: today)
        let earliest = calendar.date(byAdding: .year, value: -maximumAge, to: start) ?? start
        let latest = calendar.date(byAdding: .year, value: -minimumAge, to: start) ?? start
        return earliest...latest
    }

    /// Returns whether a date of birth is allowed on a given day.
    ///
    /// - Parameters:
    ///   - birthDate: The date of birth to check.
    ///   - today: The current date.
    ///   - calendar: The calendar that counts years.
    /// - Returns: `true` when the person is at least ``minimumAge`` years old.
    public static func isAllowed(_ birthDate: Date, today: Date = .now, calendar: Calendar = .current) -> Bool {
        allowedRange(today: today, calendar: calendar).contains(calendar.startOfDay(for: birthDate))
    }
}
