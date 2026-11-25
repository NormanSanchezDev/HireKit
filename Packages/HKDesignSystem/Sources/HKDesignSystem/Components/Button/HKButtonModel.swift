import SwiftUI

/// The content, appearance and action of an ``HKButton``.
public struct HKButtonModel {
    /// The localized button title.
    public let title: LocalizedStringKey
    /// The optional SF Symbol displayed alongside the title.
    public let systemImage: String?
    /// The visual treatment of the action.
    public let type: HKButtonType
    /// Whether the action is in progress.
    public let isLoading: Bool
    /// Whether interaction is allowed when the button is idle.
    public let isEnabled: Bool
    /// The action performed when the button is activated.
    public let action: () -> Void

    /// Creates a button configuration.
    ///
    /// - Parameters:
    ///   - title: The localized title.
    ///   - systemImage: An optional SF Symbol name.
    ///   - variant: The visual treatment of the button.
    ///   - isLoading: Whether to show progress and suspend interaction.
    ///   - isEnabled: Whether to allow interaction when idle.
    ///   - action: The action to perform on activation.
    public init(
        title: LocalizedStringKey,
        systemImage: String? = nil,
        variant: HKButtonType = .filled,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.type = variant
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }
}
