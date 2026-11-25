import Foundation

/// The `dd/mm/yyyy` mask of ``HKDatePicker``.
///
/// People type only digits and the mask adds the slashes:
///
/// ```swift
/// HKDateFormat.format("04061994")
/// HKDateFormat.edit(from: "04/06/", to: "04/06")
/// ```
///
/// The first call returns `"04/06/1994"`. The second returns `"04/0"`:
/// deleting a slash also deletes the digit before it.
public enum HKDateFormat {
    /// The number of digits of a full date.
    public static let digitCount = 8

    /// Returns the digits of a text, up to ``digitCount``.
    ///
    /// - Parameter text: The text the person typed or pasted.
    /// - Returns: At most ``digitCount`` digits.
    public static func digits(in text: String) -> String {
        String(text.filter { $0.isASCII && $0.isNumber }.prefix(digitCount))
    }

    /// Returns digits with the mask applied as far as they go.
    ///
    /// A slash follows the day and the month as soon as they are complete,
    /// so `"04"` becomes `"04/"` and `"0406"` becomes `"04/06/"`.
    ///
    /// - Parameter digits: The digits to format.
    /// - Returns: The formatted text.
    public static func format(_ digits: String) -> String {
        let value = Array(Self.digits(in: digits))
        var text = ""
        for (index, digit) in value.enumerated() {
            text.append(digit)
            if index == 1 || index == 3 { text.append("/") }
        }
        return text
    }

    /// Returns the formatted text after an edit.
    ///
    /// When an edit removes only a slash, it also removes the digit before
    /// it, so backspace never gets stuck on a separator.
    ///
    /// - Parameters:
    ///   - oldText: The text before the edit.
    ///   - newText: The text after the edit.
    /// - Returns: The formatted text to show.
    public static func edit(from oldText: String, to newText: String) -> String {
        var newDigits = digits(in: newText)
        let removedOnlySeparator = newText.count < oldText.count && newDigits == digits(in: oldText)
        if removedOnlySeparator { newDigits.removeLast() }
        return format(newDigits)
    }

    /// Returns the date that a full set of digits describes.
    ///
    /// - Parameters:
    ///   - digits: The day, month and year digits, `ddMMyyyy`.
    ///   - calendar: The calendar and time zone that define the day.
    /// - Returns: The date, or `nil` when the digits are incomplete or name a
    ///   day that does not exist, such as `31021990`.
    public static func date(fromDigits digits: String, calendar: Calendar = .current) -> Date? {
        let value = Array(Self.digits(in: digits))
        guard value.count == digitCount,
              let day = Int(String(value[0..<2])),
              let month = Int(String(value[2..<4])),
              let year = Int(String(value[4..<8])),
              let date = calendar.date(from: DateComponents(year: year, month: month, day: day))
        else { return nil }
        let check = calendar.dateComponents([.year, .month, .day], from: date)
        return check.year == year && check.month == month && check.day == day ? date : nil
    }

    /// Returns a date as the mask shows it.
    ///
    /// - Parameters:
    ///   - date: The date to show.
    ///   - calendar: The calendar and time zone that define the day.
    /// - Returns: The day, month and year, such as `04/06/1994`.
    public static func text(for date: Date, calendar: Calendar = .current) -> String {
        let style = Date.VerbatimFormatStyle(
            format: "\(day: .twoDigits)/\(month: .twoDigits)/\(year: .padded(4))",
            timeZone: calendar.timeZone,
            calendar: calendar
        )
        return date.formatted(style)
    }
}
