import Foundation

/// The project URL and publishable key that connect HireKit to Supabase.
///
/// The app reads them from a `Supabase.plist` file in its bundle, which is
/// kept out of Git. Copy `Config/Supabase.example.plist` to
/// `HireKit/Supabase.plist` and fill in the values from the Supabase dashboard.
public struct SupabaseConfiguration: Sendable, Equatable {
    /// The name of the property list in the app bundle.
    public static let resourceName = "Supabase"

    /// The project URL, such as `https://<project>.supabase.co`.
    public let url: URL

    /// The publishable (anon) key. It is safe in the client only with row
    /// level security enabled on every table.
    public let publishableKey: String

    /// Creates a configuration.
    ///
    /// - Parameters:
    ///   - url: The project URL.
    ///   - publishableKey: The publishable (anon) key.
    public init(url: URL, publishableKey: String) {
        self.url = url
        self.publishableKey = publishableKey
    }

    /// Creates a configuration from the `SupabaseURL` and
    /// `SupabasePublishableKey` entries of a property list.
    ///
    /// - Parameter propertyList: The decoded property list.
    /// - Returns: `nil` when a value is missing, empty or not a valid HTTPS URL.
    public init?(propertyList: [String: Any]) {
        guard
            let urlString = propertyList[Key.url] as? String,
            let url = URL(string: urlString.trimmingCharacters(in: .whitespacesAndNewlines)),
            url.scheme == "https",
            url.host() != nil,
            let key = (propertyList[Key.publishableKey] as? String)?
                .trimmingCharacters(in: .whitespacesAndNewlines),
            !key.isEmpty
        else { return nil }
        self.init(url: url, publishableKey: key)
    }

    /// Reads the configuration from `Supabase.plist` in a bundle.
    ///
    /// - Parameter bundle: The bundle that contains the property list.
    /// - Returns: `nil` when the file is missing or invalid.
    public init?(bundle: Bundle) {
        guard
            let fileURL = bundle.url(forResource: Self.resourceName, withExtension: "plist"),
            let data = try? Data(contentsOf: fileURL),
            let propertyList = try? PropertyListSerialization.propertyList(from: data, format: nil),
            let dictionary = propertyList as? [String: Any]
        else { return nil }
        self.init(propertyList: dictionary)
    }

    private enum Key {
        static let url = "SupabaseURL"
        static let publishableKey = "SupabasePublishableKey"
    }
}
