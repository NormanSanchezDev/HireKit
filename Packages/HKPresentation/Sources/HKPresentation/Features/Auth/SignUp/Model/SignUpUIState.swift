import HKDesignSystem
import SwiftUI

/// The display content and interaction state of the sign-up introduction.
///
/// ``SignUpViewModel`` creates it in ``SignUpViewModel/onAppear(allowsAutoAdvance:)``
/// and owns every change, so the view only renders it.
public struct SignUpUIState {
    /// The animation at the top of the screen.
    public let animation = HKAnimationModel(name: "hk_sign_up", fallback: .system("person.crop.circle.badge.plus"))

    /// The side length of the animation.
    public let animationSize: CGFloat = 160

    /// The screen heading.
    public let titleLabel = HKLabelModel(text: "sign_up_title_txt", type: .title, tone: .accent)

    /// The supporting text below the heading.
    public let descriptionLabel = HKLabelModel(text: "sign_up_description_txt", type: .subheadline)

    /// The title of the navigation bar.
    public let navigationTitle: LocalizedStringKey = "sign_up_navigation_title_txt"

    /// The registration stages, in order.
    public let steps = SignUpStep.allCases

    /// The position of the stage on screen.
    public internal(set) var selectedStep = 0

    /// Whether the carousel advances on its own. It is off with Reduce Motion or VoiceOver.
    public internal(set) var isAutoAdvanceEnabled = true

    let onStart: () -> Void
    let onSignIn: () -> Void

    /// The carousel of registration stages.
    public var carousel: HKStepCarouselModel {
        HKStepCarouselModel(
            items: steps.enumerated().map { index, step in step.carouselItem(at: index) },
            selectedIndex: selectedStep
        )
    }

    /// The button that starts the registration.
    public var startButton: HKButtonModel {
        HKButtonModel(title: "sign_up_start_button_txt", action: onStart)
    }

    /// The action that returns to sign in.
    public var signInButton: HKButtonModel {
        HKButtonModel(title: "sign_up_existing_account_button_txt", variant: .text, action: onSignIn)
    }
}
