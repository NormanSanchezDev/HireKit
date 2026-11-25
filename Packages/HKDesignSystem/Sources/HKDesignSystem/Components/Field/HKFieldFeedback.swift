import SwiftUI

/// The visible and spoken form of an ``HKFieldValidation``.
struct HKFieldFeedback {
    let message: LocalizedStringKey
    let icon: String
    let color: Color
    let description: Text
}

extension HKFieldValidation {
    func feedback(in colors: HKColors) -> HKFieldFeedback? {
        switch self {
        case .none:
            nil
        case .success(let text):
            HKFieldFeedback(message: text, icon: "checkmark.circle", color: colors.success, description: Text("common_validation_success_\(Text(text))"))
        case .warning(let text):
            HKFieldFeedback(message: text, icon: "exclamationmark.triangle", color: colors.warning, description: Text("common_validation_warning_\(Text(text))"))
        case .error(let text):
            HKFieldFeedback(message: text, icon: "exclamationmark.circle", color: colors.error, description: Text("common_validation_error_\(Text(text))"))
        }
    }
}

extension Text {
    /// Creates the spoken label of a field, which says when it is required.
    init(fieldTitle title: LocalizedStringKey, isRequired: Bool) {
        self = isRequired ? Text("common_required_\(Text(title))") : Text(title)
    }
}
