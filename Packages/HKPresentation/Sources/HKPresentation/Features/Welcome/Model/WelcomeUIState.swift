import HKDesignSystem
import SwiftUI

/// The content and interaction state rendered by the welcome screen.
public struct WelcomeUIState {
    /// The side length of the welcome illustration.
    public let imageSize: CGFloat = 300

    /// The illustration in the design system's media catalog.
    public let imageResourceName = "hk_programmer_memoji"

    /// The localized heading.
    public let title: LocalizedStringKey = "welcome_title_txt"

    /// The localized introduction.
    public let description: LocalizedStringKey = "welcome_description_txt"

    /// The prompt displayed above the start button.
    public let prompt: LocalizedStringKey = "welcome_prompt_txt"

    /// The title of the save-error alert.
    public let errorTitle: LocalizedStringKey = "common_error_title"

    /// The alert's dismissal action title.
    public let dismissTitle: LocalizedStringKey = "common_ok"

    /// Whether onboarding progress is being saved.
    public internal(set) var isLoading = false

    /// The localized save error, when present.
    public internal(set) var errorMessage: LocalizedStringKey?

    let onStart: () -> Void

    /// The action and current loading indicator for the start button.
    public var startButton: HKButtonModel {
        HKButtonModel(title: "welcome_start_button_txt", isLoading: isLoading, action: onStart)
    }
}
