/// The ten-digit phone mask of ``HKPhoneField``, `(XX) XX XX XX XX`.
///
/// ```swift
/// HKPhoneFormat.format("5625068370")
/// HKPhoneFormat.digits(in: "(56) 25 06 83 70")
/// ```
///
/// The first call returns `"(56) 25 06 83 70"` and the second `"5625068370"`.
public enum HKPhoneFormat {
    /// The number of digits the mask holds.
    public static let digitCount = 10

    /// Returns the digits of a text, up to ``digitCount``.
    ///
    /// Text that starts with `+`, as AutoFill inserts it, keeps its last
    /// digits so the country code is dropped.
    ///
    /// - Parameter text: The text the person typed or pasted.
    /// - Returns: At most ``digitCount`` digits.
    public static func digits(in text: String) -> String {
        let all = text.filter { $0.isASCII && $0.isNumber }
        let trimmed = text.trimmingPrefix(while: \.isWhitespace)
        return String(trimmed.hasPrefix("+") ? all.suffix(digitCount) : all.prefix(digitCount))
    }

    /// Returns digits with the mask applied as far as they go.
    ///
    /// Separators appear only before a digit, so deleting a character always
    /// removes a digit: `"56"` becomes `"(56"` and `"562"` becomes `"(56) 2"`.
    ///
    /// - Parameter digits: The digits to format.
    /// - Returns: The formatted text.
    public static func format(_ digits: String) -> String {
        let value = Array(Self.digits(in: digits))
        guard !value.isEmpty else { return "" }
        var text = "(" + String(value.prefix(2))
        var index = 2
        while index < value.count {
            text += index == 2 ? ") " : " "
            text += String(value[index..<min(index + 2, value.count)])
            index += 2
        }
        return text
    }
}
