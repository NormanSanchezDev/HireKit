/// Screens pushed inside the authentication flow. Sign in is the root.
public enum AuthRoute: HKRoute {
    /// The sign-in screen.
    case signIn

    /// The sign-up introduction, which lists the registration steps.
    case signUp

    /// The first sign-up step: names and date of birth.
    case personalInformation

    /// The second sign-up step: email, phone and password.
    case contactInformation
}
