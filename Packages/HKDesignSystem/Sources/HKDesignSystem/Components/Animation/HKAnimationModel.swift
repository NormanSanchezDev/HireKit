import Foundation
import Lottie

/// The Lottie animation of an ``HKAnimation`` and the image shown when it
/// cannot load.
///
/// ```swift
/// HKAnimationModel(name: "hk_sign_up", fallback: .system("person.crop.circle.badge.plus"))
/// ```
public struct HKAnimationModel {
    /// The file name of the Lottie JSON, without extension.
    public let name: String

    /// The bundle that holds the JSON, or `nil` for the design system's own.
    public let bundle: Bundle?

    /// The image shown when the animation cannot load.
    public let fallback: HKImageSource

    /// Creates an animation model.
    ///
    /// - Parameters:
    ///   - name: The file name of the Lottie JSON, without extension.
    ///   - bundle: The bundle that holds the JSON. Pass `nil` to load it from
    ///     the design system's resources.
    ///   - fallback: The image shown when the animation cannot load.
    public init(name: String, bundle: Bundle? = nil, fallback: HKImageSource) {
        self.name = name
        self.bundle = bundle
        self.fallback = fallback
    }

    var animation: LottieAnimation? {
        LottieAnimation.named(name, bundle: bundle ?? .module)
    }
}
