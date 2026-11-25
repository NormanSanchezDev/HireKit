/// The validation feedback that an ``HKField`` shows below its input.
///
/// Each state pairs a color with an icon, so the feedback stays clear for
/// people who cannot tell the colors apart.
public enum HKFieldValidation: Equatable, Sendable {
    /// No feedback.
    case none

    /// A confirmation, such as a verified address.
    case success(String)

    /// A non-blocking issue, such as a weak password.
    case warning(String)

    /// A blocking issue that the user must fix before continuing.
    case error(String)
}
