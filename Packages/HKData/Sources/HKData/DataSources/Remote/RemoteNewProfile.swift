/// The profile of a new account as the auth backend stores it.
///
/// Every value is a plain string, ready to send without further formatting.
public struct RemoteNewProfile: Sendable, Equatable {
    /// The person's given names.
    public let firstName: String

    /// The person's paternal surname.
    public let paternalLastName: String

    /// The person's maternal surname, if any.
    public let maternalLastName: String?

    /// The date of birth in `yyyy-MM-dd` format.
    public let birthDate: String

    /// The country calling code, such as `+52`.
    public let dialCode: String

    /// The ten-digit national phone number, digits only.
    public let phone: String

    /// Creates a remote profile.
    ///
    /// - Parameters:
    ///   - firstName: The person's given names.
    ///   - paternalLastName: The person's paternal surname.
    ///   - maternalLastName: The person's maternal surname, if any.
    ///   - birthDate: The date of birth in `yyyy-MM-dd` format.
    ///   - dialCode: The country calling code, such as `+52`.
    ///   - phone: The ten-digit national phone number, digits only.
    public init(
        firstName: String,
        paternalLastName: String,
        maternalLastName: String?,
        birthDate: String,
        dialCode: String,
        phone: String
    ) {
        self.firstName = firstName
        self.paternalLastName = paternalLastName
        self.maternalLastName = maternalLastName
        self.birthDate = birthDate
        self.dialCode = dialCode
        self.phone = phone
    }
}
