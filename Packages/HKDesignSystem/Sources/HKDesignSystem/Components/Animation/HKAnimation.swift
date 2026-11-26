import Lottie
import SwiftUI

/// A decorative Lottie animation that loops while it is visible.
///
/// When the animation file cannot load, the view shows the model's fallback
/// image instead. When Reduce Motion is on, it shows the first frame without
/// playing. Set the size from the caller:
///
/// ```swift
/// HKAnimation(model: .init(name: "hk_sign_up", fallback: .system("person.crop.circle.badge.plus")))
///     .frame(width: 160, height: 160)
/// ```
///
/// The animation is hidden from VoiceOver.
public struct HKAnimation: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.hkTheme) private var theme

    private let model: HKAnimationModel

    /// Creates an animation.
    ///
    /// - Parameter model: The animation and its fallback image.
    public init(model: HKAnimationModel) {
        self.model = model
    }

    public var body: some View {
        Group {
            if let animation = model.animation {
                LottieView(animation: animation)
                    .playbackMode(playbackMode)
                    .resizable()
            } else {
                HKImage(model.fallback, tint: theme.colors.primary)
            }
        }
        .accessibilityHidden(true)
    }

    private var playbackMode: LottiePlaybackMode {
        reduceMotion
            ? .paused(at: .progress(0))
            : .playing(.fromProgress(0, toProgress: 1, loopMode: .loop))
    }
}

#Preview("Animation and fallback") {
    HStack(spacing: 24) {
        HKAnimation(model: .init(name: "hk_sign_up", fallback: .system("person.crop.circle.badge.plus")))
        HKAnimation(model: .init(name: "missing", fallback: .system("person.crop.circle.badge.plus")))
    }
    .frame(height: 160)
    .padding()
    .hkBackground()
}
