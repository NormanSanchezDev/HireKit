import Foundation

/// The profile and credentials a person provides to create an account.
public struct NewAccount: Sendable, Equatable {
    /// The person's given names.
    public let firstName: String

    /// The person's paternal surname.
    public let paternalLastName: String

    /// The person's maternal surname, if they have one.
    public let maternalLastName: String?

    /// The person's date of birth.
    public let birthDate: Date

    /// The person's phone number.
    public let phone: PhoneNumber

    /// The email and password of the new account.
    public let credentials: AuthCredentials

    /// Creates the data of a new account.
    ///
    /// - Parameters:
    ///   - firstName: The person's given names.
    ///   - paternalLastName: The person's paternal surname.
    ///   - maternalLastName: The person's maternal surname, if any.
    ///   - birthDate: The person's date of birth.
    ///   - phone: The person's phone number.
    ///   - credentials: The email and password of the new account.
    public init(
        firstName: String,
        paternalLastName: String,
        maternalLastName: String?,
        birthDate: Date,
        phone: PhoneNumber,
        credentials: AuthCredentials
    ) {
        self.firstName = firstName
        self.paternalLastName = paternalLastName
        self.maternalLastName = maternalLastName
        self.birthDate = birthDate
        self.phone = phone
        self.credentials = credentials
    }

    /// Creates the data of a new account from the two sign-up steps.
    ///
    /// An empty maternal surname means the person has none.
    ///
    /// - Parameters:
    ///   - personal: The personal details of the first step.
    ///   - contact: The contact details and password of the second step.
    /// - Returns: `nil` when the personal details have no date of birth.
    public init?(personal: PersonalInformation, contact: ContactInformation) {
        guard let birthDate = personal.birthDate else { return nil }
        self.init(
            firstName: personal.firstName,
            paternalLastName: personal.paternalLastName,
            maternalLastName: personal.maternalLastName.isEmpty ? nil : personal.maternalLastName,
            birthDate: birthDate,
            phone: contact.phone,
            credentials: AuthCredentials(email: contact.email, password: contact.password)
        )
    }

    /// The account with cleaned names, an empty maternal surname removed and
    /// the credentials normalized.
    var normalized: NewAccount {
        let maternal = maternalLastName.map(PersonName.cleaned)
        return NewAccount(
            firstName: PersonName.cleaned(firstName),
            paternalLastName: PersonName.cleaned(paternalLastName),
            maternalLastName: maternal?.isEmpty == false ? maternal : nil,
            birthDate: birthDate,
            phone: phone,
            credentials: credentials.normalized
        )
    }
}
