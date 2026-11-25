import HKDomain
import SwiftUI

extension AuthenticationError {
    /// The localized message shown when a sign-in or sign-up request fails.
    var message: LocalizedStringKey {
        switch self {
        case .invalidCredentials: "auth_error_invalid_credentials_txt"
        case .emailNotConfirmed: "auth_error_email_not_confirmed_txt"
        case .emailAlreadyRegistered: "auth_error_email_already_registered_txt"
        case .weakPassword: "auth_error_weak_password_txt"
        case .rateLimited: "auth_error_rate_limited_txt"
        case .network: "auth_error_network_txt"
        case .notConfigured: "auth_error_not_configured_txt"
        case .unknown: "auth_error_unknown_txt"
        }
    }
}
