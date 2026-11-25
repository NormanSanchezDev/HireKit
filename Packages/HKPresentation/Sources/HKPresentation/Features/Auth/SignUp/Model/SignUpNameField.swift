/// A name field of the sign-up form that is cleaned when it loses focus.
public enum SignUpNameField: Sendable {
    /// The given names.
    case firstName

    /// The paternal surname.
    case paternalLastName

    /// The optional maternal surname.
    case maternalLastName
}
