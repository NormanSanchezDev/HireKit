/// A ten-digit phone number and its country calling code.
///
/// The calling code and the national number are stored apart:
///
/// ```swift
/// let phone = PhoneNumber(dialCode: .mexico, digits: "(56) 25 06 83 70")
/// ```
///
/// `phone?.nationalNumber` is `"5625068370"`.
public struct PhoneNumber: Sendable, Equatable {
    /// The number of digits of a national number.
    public static let digitCount = 10

    /// The country calling code.
    public let dialCode: DialCode

    /// The national number, with digits only.
    public let nationalNumber: String

    /// Creates a phone number, ignoring every character that is not a digit.
    ///
    /// - Parameters:
    ///   - dialCode: The country calling code.
    ///   - digits: The number the person typed, formatted or not.
    /// - Returns: `nil` unless the text has exactly ``digitCount`` digits.
    public init?(dialCode: DialCode, digits: String) {
        let nationalNumber = String(digits.filter { $0.isASCII && $0.isNumber })
        guard nationalNumber.count == Self.digitCount else { return nil }
        self.dialCode = dialCode
        self.nationalNumber = nationalNumber
    }
}
