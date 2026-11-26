/// A name field of the personal information step that is cleaned and
/// validated when it loses focus.
public enum PersonalInformationField: Sendable {
    /// The given names.
    case firstName

    /// The paternal surname.
    case paternalLastName

    /// The optional maternal surname.
    case maternalLastName
}
