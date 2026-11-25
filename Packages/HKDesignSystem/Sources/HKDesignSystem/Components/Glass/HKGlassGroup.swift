import SwiftUI

/// A container that lets nearby Liquid Glass shapes blend and morph together.
///
/// Glass cannot sample other glass, so separate glass views look flat when
/// they sit close together. Wrap them in a group to render them as one
/// material, with fluid morphing when they appear, move or disappear:
///
/// ```swift
/// HKGlassGroup(spacing: 12) {
///     HStack(spacing: 12) {
///         HKButton(model: .init(title: "common_cancel", variant: .outline) { })
///         HKButton(model: .init(title: "common_save") { })
///     }
/// }
/// ```
///
/// Supply a stack or another layout as the content.
public struct HKGlassGroup<Content: View>: View {
    private let spacing: CGFloat?
    private let content: Content

    /// Creates a glass group.
    ///
    /// - Parameters:
    ///   - spacing: The distance at which glass shapes start to merge. Match it
    ///     to the spacing of the layout inside. Pass `nil` for the system default.
    ///   - content: The glass views to group, inside a layout.
    public init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        GlassEffectContainer(spacing: spacing) { content }
    }
}

#Preview("Grouped actions") {
    HKGlassGroup(spacing: 12) {
        HStack(spacing: 12) {
            HKButton(model: .init(title: "common_cancel", variant: .outline) {})
            HKButton(model: .init(title: "common_save") {})
        }
    }
    .padding()
    .hkBackground()
}
