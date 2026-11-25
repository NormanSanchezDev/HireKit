import SwiftUI

/// How a field capitalizes the text the person types.
///
/// It applies to the software keyboard on iOS and has no effect on macOS.
public enum HKFieldCapitalization: Sendable {
    /// No automatic capitalization, for emails and identifiers.
    case never

    /// The first letter of each word, for names.
    case words

    /// The first letter of each sentence.
    case sentences

    #if os(iOS)
    var textInputAutocapitalization: TextInputAutocapitalization {
        switch self {
        case .never: .never
        case .words: .words
        case .sentences: .sentences
        }
    }
    #endif
}
