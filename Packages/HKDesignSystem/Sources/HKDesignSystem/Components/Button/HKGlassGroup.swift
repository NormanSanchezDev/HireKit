import SwiftUI

/**
 * Groups nearby glass controls so they blend and morph together.
 * Supply a stack or another layout as the content.
 */
public struct HKGlassGroup<Content: View>: View {
    private let spacing: CGFloat?
    private let content: Content

    public init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        GlassEffectContainer(spacing: spacing) { content }
    }
}

#Preview("Grouped actions") {
    HKGlassGroup {
        HStack {
            HKButton("Cancel", variant: .secondary) {}
            HKButton("Save") {}
        }
    }
    .padding()
    .environment(HKThemeManager(defaults: nil))
}
