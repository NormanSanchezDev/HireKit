import HKDomain
import Observation

/// The values typed during sign-up, shared by its steps.
///
/// The auth flow owns one draft, so the data stays when the person goes back
/// and forth between the steps. The draft lives only in memory and never
/// holds the password.
@MainActor
@Observable
public final class SignUpDraft {
    /// The names and date of birth of the first step.
    public var personal = PersonalInformation()

    /// The email the person typed in the second step.
    public var email = ""

    /// The calling code of the phone number.
    public var dialCode = DialCode.mexico

    /// The national phone number, digits only.
    public var phoneDigits = ""

    /// Creates an empty draft.
    public init() {}

    /// Clears every value, after the account is created.
    public func reset() {
        personal = PersonalInformation()
        email = ""
        dialCode = .mexico
        phoneDigits = ""
    }
}
