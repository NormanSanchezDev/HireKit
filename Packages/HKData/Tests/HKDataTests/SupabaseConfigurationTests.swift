import Foundation
import HKData
import Testing

struct SupabaseConfigurationTests {
    @Test func validPropertyListCreatesConfiguration() throws {
        let configuration = try #require(SupabaseConfiguration(propertyList: [
            "SupabaseURL": " https://example.supabase.co ",
            "SupabasePublishableKey": " sb_publishable_test ",
        ]))
        #expect(configuration.url.absoluteString == "https://example.supabase.co")
        #expect(configuration.publishableKey == "sb_publishable_test")
    }

    @Test(arguments: [
        [String: String](),
        ["SupabaseURL": "https://example.supabase.co"],
        ["SupabaseURL": "https://example.supabase.co", "SupabasePublishableKey": "  "],
        ["SupabaseURL": "http://example.supabase.co", "SupabasePublishableKey": "key"],
        ["SupabaseURL": "no es una url", "SupabasePublishableKey": "key"],
    ])
    func invalidPropertyListIsRejected(values: [String: String]) {
        #expect(SupabaseConfiguration(propertyList: values) == nil)
    }

    @Test func bundleWithoutPropertyListHasNoConfiguration() {
        #expect(SupabaseConfiguration(bundle: Bundle(for: BundleToken.self)) == nil)
    }

    private final class BundleToken {}
}
