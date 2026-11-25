import Foundation

/// The rules for a person's given names and surnames.
///
/// Clean what the person typed before validating or saving it:
///
/// ```swift
/// let name = PersonName.cleaned(" CArlos.  arTURO ")
/// PersonName.isValid(name)
/// ```
///
/// `name` is `"Carlos Arturo"` and the check returns `true`.
public enum PersonName {
    /// Returns the name with only letters, spaces, apostrophes and hyphens,
    /// single spaces between words and each word capitalized.
    ///
    /// Any other character, such as a period or a digit, becomes a space, so
    /// `"Carlos.Arturo"` becomes `"Carlos Arturo"`.
    ///
    /// - Parameter name: The text the person typed.
    /// - Returns: The cleaned name, or an empty string when nothing is left.
    public static func cleaned(_ name: String) -> String {
        let kept = String(name.map { isAllowed($0) ? $0 : " " })
        return kept
            .split(separator: " ", omittingEmptySubsequences: true)
            .map { capitalized(String($0)) }
            .joined(separator: " ")
    }

    /// Returns whether a name starts with a capital letter, has at least two
    /// letters and has single spaces between capitalized words.
    ///
    /// - Parameter name: The name to check, usually already ``cleaned(_:)``.
    /// - Returns: `true` when the name is acceptable.
    public static func isValid(_ name: String) -> Bool {
        name.wholeMatch(of: /\p{Lu}[\p{L}'’\-]+(?: \p{Lu}[\p{L}'’\-]*)*/) != nil
    }

    private static func isAllowed(_ character: Character) -> Bool {
        character.isLetter || character == " " || character == "'" || character == "’" || character == "-"
    }

    private static func capitalized(_ word: String) -> String {
        word.split(separator: "-", omittingEmptySubsequences: false)
            .map { part in part.prefix(1).uppercased() + part.dropFirst().lowercased() }
            .joined(separator: "-")
    }
}
