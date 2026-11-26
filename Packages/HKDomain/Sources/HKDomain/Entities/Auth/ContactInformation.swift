/// The validated contact details and password a person enters in the second
/// step of sign-up.
///
/// ```swift
/// let contact = ContactInformation(
///     email: "ana@hirekit.app",
///     phone: phone,
///     password: password
/// )
/// ```
public struct ContactInformation: Equatable, Sendable {
    /// The email address of the new account.
    public let email: String

    /// The person's phone number.
    public let phone: PhoneNumber

    /// The password of the new account.
    public let password: String

    /// Creates contact details.
    ///
    /// - Parameters:
    ///   - email: The email address of the new account.
    ///   - phone: The person's phone number.
    ///   - password: The password of the new account.
    public init(email: String, phone: PhoneNumber, password: String) {
        self.email = email
        self.phone = phone
        self.password = password
    }
}
