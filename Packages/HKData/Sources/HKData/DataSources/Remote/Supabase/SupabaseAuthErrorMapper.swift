import Foundation
import HKDomain
import Supabase

/// Translates errors thrown by the Supabase SDK into `AuthenticationError`.
enum SupabaseAuthErrorMapper {
    /// Returns the domain error for any error thrown during an auth request.
    ///
    /// - Parameter error: The error the SDK or `URLSession` threw.
    /// - Returns: The matching `AuthenticationError`, or `.unknown`.
    static func map(_ error: any Error) -> AuthenticationError {
        if let authError = error as? AuthenticationError { return authError }
        if error is URLError { return .network }
        if let supabaseError = error as? Auth.AuthError { return map(supabaseError.errorCode) }
        return .unknown
    }

    private static func map(_ code: Auth.ErrorCode) -> AuthenticationError {
        switch code {
        case .invalidCredentials: .invalidCredentials
        case .emailNotConfirmed: .emailNotConfirmed
        case .userAlreadyExists, .emailExists: .emailAlreadyRegistered
        case .weakPassword: .weakPassword
        case .overRequestRateLimit, .overEmailSendRateLimit: .rateLimited
        default: .unknown
        }
    }
}
