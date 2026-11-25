import SwiftUI

/// The content and configuration of an ``HKField``.
///
/// ```swift
/// HKFieldModel(
///     title: "common_email",
///     placeholder: "common_email_placeholder",
///     icon: "envelope",
///     contentType: .emailAddress,
///     isRequired: true,
///     errorMessage: viewModel.emailError
/// )
/// ```
public struct HKFieldModel {
    /// The title shown above the input. VoiceOver reads it as the field's label.
    public let title: LocalizedStringKey

    /// The hint shown inside the input while it is empty.
    public let placeholder: LocalizedStringKey

    /// The name of an SF Symbol shown before the input.
    public let icon: String?

    /// The semantic meaning of the text, for AutoFill and the keyboard.
    public let contentType: HKFieldContentType?

    /// Whether the input hides its text, with a button to reveal it.
    public let isSecure: Bool

    /// Whether the field is required during validation.
    public let isRequired: Bool

    /// Whether the user can edit the field.
    public let isEnabled: Bool

    /// The feedback shown below the input.
    public let validation: HKFieldValidation

    /// The message of an ``HKFieldValidation/error(_:)`` validation, if any.
    public var errorMessage: LocalizedStringKey? {
        if case let .error(message) = validation { message } else { nil }
    }

    /// Creates a field model.
    ///
    /// - Parameters:
    ///   - title: The title shown above the input.
    ///   - placeholder: The hint shown inside the empty input.
    ///   - icon: The name of an SF Symbol shown before the input.
    ///   - contentType: The semantic meaning of the text, for AutoFill.
    ///   - isSecure: Whether the input hides its text.
    ///   - isRequired: Whether the field is required during validation.
    ///   - errorMessage: A shortcut for an ``HKFieldValidation/error(_:)``
    ///     validation. When it is not `nil`, it replaces `validation`.
    ///   - isEnabled: Whether the user can edit the field.
    ///   - validation: The feedback shown below the input.
    public init(
        title: LocalizedStringKey,
        placeholder: LocalizedStringKey = "",
        icon: String? = nil,
        contentType: HKFieldContentType? = nil,
        isSecure: Bool = false,
        isRequired: Bool = false,
        errorMessage: LocalizedStringKey? = nil,
        isEnabled: Bool = true,
        validation: HKFieldValidation = .none
    ) {
        self.title = title
        self.placeholder = placeholder
        self.icon = icon
        self.contentType = contentType
        self.isSecure = isSecure
        self.isRequired = isRequired
        self.isEnabled = isEnabled
        self.validation = errorMessage.map(HKFieldValidation.error) ?? validation
    }

    #if os(iOS)
    /// The keyboard shown while the field is focused.
    public private(set) var keyboardType: UIKeyboardType = .default

    /// Creates a field model with a specific keyboard.
    ///
    /// - Parameters:
    ///   - title: The title shown above the input.
    ///   - placeholder: The hint shown inside the empty input.
    ///   - icon: The name of an SF Symbol shown before the input.
    ///   - contentType: The semantic meaning of the text, for AutoFill.
    ///   - keyboardType: The keyboard shown while the field is focused.
    ///   - isSecure: Whether the input hides its text.
    ///   - isRequired: Whether the field is required during validation.
    ///   - errorMessage: A shortcut for an ``HKFieldValidation/error(_:)``
    ///     validation. When it is not `nil`, it replaces `validation`.
    ///   - isEnabled: Whether the user can edit the field.
    ///   - validation: The feedback shown below the input.
    public init(
        title: LocalizedStringKey,
        placeholder: LocalizedStringKey = "",
        icon: String? = nil,
        contentType: HKFieldContentType? = nil,
        keyboardType: UIKeyboardType,
        isSecure: Bool = false,
        isRequired: Bool = false,
        errorMessage: LocalizedStringKey? = nil,
        isEnabled: Bool = true,
        validation: HKFieldValidation = .none
    ) {
        self.init(
            title: title, placeholder: placeholder, icon: icon, contentType: contentType,
            isSecure: isSecure, isRequired: isRequired, errorMessage: errorMessage,
            isEnabled: isEnabled, validation: validation
        )
        self.keyboardType = keyboardType
    }
    #endif
}
