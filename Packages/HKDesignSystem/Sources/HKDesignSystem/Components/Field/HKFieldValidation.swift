import SwiftUI

/// The validation feedback that an ``HKField`` shows below its input.
///
/// Each state pairs a color with an icon, so the feedback stays clear for
/// people who cannot tell the colors apart.
public enum HKFieldValidation: Equatable {
    /// No feedback.
    case none

    /// A confirmation, such as a verified address.
    case success(LocalizedStringKey)

    /// A non-blocking issue, such as a weak password.
    case warning(LocalizedStringKey)

    /// A blocking issue that the user must fix before continuing.
    case error(LocalizedStringKey)
}
