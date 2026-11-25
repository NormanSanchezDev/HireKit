import SwiftUI

/// The place an ``HKImage`` loads its image from.
///
/// ```swift
/// HKImage(.media("hk_placeholder"))
/// HKImage(.asset("company_logo"))
/// HKImage(.resource(.hkPlaceholder))
/// HKImage(.system("briefcase.fill"), tint: .indigo)
/// ```
public enum HKImageSource {
    /// An image in the design system's `Media.xcassets`, by name.
    case media(String)

    /// An image in an asset catalog, by name.
    ///
    /// The image loads from the app's main bundle, or from `bundle` when you
    /// pass one, for example `.module` inside another package.
    case asset(String, bundle: Bundle? = nil)

    /// A type-safe image resource that Xcode generates for an asset catalog.
    case resource(ImageResource)

    /// An SF Symbol, by name.
    case system(String)

    /// An image built elsewhere.
    case image(Image)

    var isSymbol: Bool {
        if case .system = self { true } else { false }
    }

    var image: Image {
        switch self {
        case .media(let name): Image(name, bundle: .module)
        case .asset(let name, let bundle): Image(name, bundle: bundle)
        case .resource(let resource): Image(resource)
        case .system(let name): Image(systemName: name)
        case .image(let image): image
        }
    }
}
