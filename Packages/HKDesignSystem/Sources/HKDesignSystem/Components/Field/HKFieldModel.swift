import SwiftUI

#if os(macOS)
public typealias HKFieldContentType = NSTextContentType
#else
public typealias HKFieldContentType = UITextContentType
#endif

public enum HKFieldValidation: Equatable, Sendable {
    case none
    case success(String)
    case warning(String)
    case error(String)
}

public struct HKFieldModel {
    public let title: String
    public let placeholder: String
    public let icon: String?
    public let contentType: HKFieldContentType?
    public let isSecure: Bool
    public let isRequired: Bool
    public let isEnabled: Bool
    public let validation: HKFieldValidation

    public var errorMessage: String? {
        if case let .error(message) = validation { message } else { nil }
    }

    public init(
        title: String,
        placeholder: String = "",
        icon: String? = nil,
        contentType: HKFieldContentType? = nil,
        isSecure: Bool = false,
        isRequired: Bool = false,
        errorMessage: String? = nil,
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
    public private(set) var keyboardType: UIKeyboardType = .default

    public init(
        title: String,
        placeholder: String = "",
        icon: String? = nil,
        contentType: HKFieldContentType? = nil,
        keyboardType: UIKeyboardType,
        isSecure: Bool = false,
        isRequired: Bool = false,
        errorMessage: String? = nil,
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
