import Foundation

/// The personal details a person enters in the first step of sign-up.
///
/// The values are what the person typed. They are validated before the
/// account is created, so `birthDate` stays optional until then:
///
/// ```swift
/// var personal = PersonalInformation()
/// personal.firstName = "Ana"
/// personal.birthDate = birthDate
/// ```
public struct PersonalInformation: Equatable, Sendable {
    /// The person's given names.
    public var firstName: String

    /// The person's paternal surname.
    public var paternalLastName: String

    /// The person's maternal surname, empty when they have none.
    public var maternalLastName: String

    /// The person's date of birth, if they entered one.
    public var birthDate: Date?

    /// Creates personal details.
    ///
    /// - Parameters:
    ///   - firstName: The person's given names.
    ///   - paternalLastName: The person's paternal surname.
    ///   - maternalLastName: The person's maternal surname, empty when none.
    ///   - birthDate: The person's date of birth, if any.
    public init(
        firstName: String = "",
        paternalLastName: String = "",
        maternalLastName: String = "",
        birthDate: Date? = nil
    ) {
        self.firstName = firstName
        self.paternalLastName = paternalLastName
        self.maternalLastName = maternalLastName
        self.birthDate = birthDate
    }
}
