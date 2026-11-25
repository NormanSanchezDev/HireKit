import Foundation
import HKDomain
import Supabase
import Testing
@testable import HKData

struct SupabaseAuthErrorMapperTests {
    private func apiError(_ code: Auth.ErrorCode) throws -> Auth.AuthError {
        let url = try #require(URL(string: "https://example.supabase.co/auth/v1/token"))
        let response = try #require(HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil))
        return .api(message: "error", errorCode: code, underlyingData: Data(), underlyingResponse: response)
    }

    @Test(arguments: [
        (Auth.ErrorCode.invalidCredentials, AuthenticationError.invalidCredentials),
        (.emailNotConfirmed, .emailNotConfirmed),
        (.userAlreadyExists, .emailAlreadyRegistered),
        (.emailExists, .emailAlreadyRegistered),
        (.weakPassword, .weakPassword),
        (.overRequestRateLimit, .rateLimited),
        (.overEmailSendRateLimit, .rateLimited),
        (.unexpectedFailure, .unknown),
    ])
    func apiErrorsMapByCode(code: Auth.ErrorCode, expected: AuthenticationError) throws {
        #expect(SupabaseAuthErrorMapper.map(try apiError(code)) == expected)
    }

    @Test func weakPasswordErrorMapsToWeakPassword() {
        let error = Auth.AuthError.weakPassword(message: "weak", reasons: ["length"])
        #expect(SupabaseAuthErrorMapper.map(error) == .weakPassword)
    }

    @Test func urlErrorsMapToNetwork() {
        #expect(SupabaseAuthErrorMapper.map(URLError(.notConnectedToInternet)) == .network)
    }

    @Test func domainErrorsPassThrough() {
        #expect(SupabaseAuthErrorMapper.map(AuthenticationError.notConfigured) == .notConfigured)
    }
}
