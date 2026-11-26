import SwiftUI

/// One page of an ``HKStepCarousel``: a symbol, a title and a description.
public struct HKStepCarouselItem: Identifiable {
    /// The position of the page, starting at zero.
    public let id: Int

    /// The SF Symbol shown above the title.
    public let systemImage: String

    /// The localized title of the page.
    public let title: LocalizedStringKey

    /// The localized description of the page.
    public let description: LocalizedStringKey

    /// Creates a carousel page.
    ///
    /// - Parameters:
    ///   - id: The position of the page, starting at zero.
    ///   - systemImage: The SF Symbol shown above the title.
    ///   - title: The localized title.
    ///   - description: The localized description.
    public init(id: Int, systemImage: String, title: LocalizedStringKey, description: LocalizedStringKey) {
        self.id = id
        self.systemImage = systemImage
        self.title = title
        self.description = description
    }
}
