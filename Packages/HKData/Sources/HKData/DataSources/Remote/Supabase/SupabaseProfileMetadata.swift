import Supabase

/// The keys under which a new account's profile is stored in Supabase user
/// metadata.
///
/// The `handle_new_user` trigger in `supabase/migrations` reads the same keys
/// to fill `public.profiles`.
enum SupabaseProfileMetadata {
    static let firstName = "first_name"
    static let paternalLastName = "paternal_last_name"
    static let maternalLastName = "maternal_last_name"
    static let birthDate = "birth_date"
    static let dialCode = "dial_code"
    static let phone = "phone"

    static func encode(_ profile: RemoteNewProfile) -> [String: AnyJSON] {
        [
            firstName: .string(profile.firstName),
            paternalLastName: .string(profile.paternalLastName),
            maternalLastName: profile.maternalLastName.map(AnyJSON.string) ?? .null,
            birthDate: .string(profile.birthDate),
            dialCode: .string(profile.dialCode),
            phone: .string(profile.phone),
        ]
    }

    static func displayName(in metadata: [String: AnyJSON]) -> String? {
        let parts = [firstName, paternalLastName].compactMap { metadata[$0]?.stringValue }
        return parts.isEmpty ? nil : parts.joined(separator: " ")
    }
}
