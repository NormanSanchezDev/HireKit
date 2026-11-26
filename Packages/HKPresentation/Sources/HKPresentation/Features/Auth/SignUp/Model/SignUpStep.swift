import HKDesignSystem
import SwiftUI

/// A stage of the registration that the sign-up introduction presents.
public enum SignUpStep: CaseIterable, Sendable {
    /// Entering names and date of birth.
    case personalInformation

    /// Entering the email, phone and password.
    case contactInformation

    /// Finishing the registration.
    case getStarted

    /// The localized title of the stage.
    public var title: LocalizedStringKey {
        switch self {
        case .personalInformation: "sign_up_step_personal_title_txt"
        case .contactInformation: "sign_up_step_contact_title_txt"
        case .getStarted: "sign_up_step_get_started_title_txt"
        }
    }

    /// The localized description of the stage.
    public var description: LocalizedStringKey {
        switch self {
        case .personalInformation: "sign_up_step_personal_description_txt"
        case .contactInformation: "sign_up_step_contact_description_txt"
        case .getStarted: "sign_up_step_get_started_description_txt"
        }
    }

    /// The SF Symbol of the stage.
    public var systemImage: String {
        switch self {
        case .personalInformation: "person.text.rectangle"
        case .contactInformation: "envelope.badge.shield.half.filled"
        case .getStarted: "checkmark.seal"
        }
    }

    func carouselItem(at index: Int) -> HKStepCarouselItem {
        HKStepCarouselItem(id: index, systemImage: systemImage, title: title, description: description)
    }
}
