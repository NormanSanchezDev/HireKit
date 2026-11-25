import SwiftUI

/// A Liquid Glass surface that groups related content.
///
/// A glass card pads its content, fills the available width and floats above
/// the content behind it:
///
/// ```swift
/// HKGlassCard {
///     VStack(alignment: .leading) {
///         HKLabel("Next interview", type: .headline)
///         HKLabel("Tomorrow, 10:00", type: .caption, tone: .secondary)
///     }
/// }
/// ```
///
/// Place cards over ``HKBackground`` or over real content so the glass has color
/// to refract. Wrap several cards in ``HKGlassGroup`` so they blend when they
/// sit close together.
public struct HKGlassCard<Content: View>: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    private let style: HKGlassStyle
    private let isInteractive: Bool
    private let content: Content

    /// Creates a glass card.
    ///
    /// - Parameters:
    ///   - style: The glass material of the card.
    ///   - isInteractive: Whether the whole card reacts to touch and pointer
    ///     input. Set it only when the card is a button or a link.
    ///   - content: The content of the card.
    public init(
        style: HKGlassStyle = .regular,
        isInteractive: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.isInteractive = isInteractive
        self.content = content()
    }

    public var body: some View {
        let theme = themeManager.current(for: colorScheme)
        content
            .padding(theme.spacing.extraLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .hkGlass(style, isInteractive: isInteractive, in: .rect(cornerRadius: theme.radius.large))
    }
}

#Preview("Glass card") {
    HKGlassGroup(spacing: 16) {
        VStack(spacing: 16) {
            HKGlassCard {
                VStack(alignment: .leading) {
                    HKLabel("Next interview", type: .headline)
                    HKLabel("Tomorrow, 10:00", type: .caption, tone: .secondary)
                }
            }
            HKGlassCard(style: .tinted(.indigo)) {
                HKLabel("Offer received", type: .headline)
            }
        }
    }
    .padding()
    .frame(maxHeight: .infinity)
    .hkBackground()
    .environment(HKThemeManager(defaults: nil))
}
