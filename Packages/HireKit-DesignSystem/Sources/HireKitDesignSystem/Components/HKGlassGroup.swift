import SwiftUI

/// Groups nearby glass controls. Supply a stack or another layout as the content.
public struct HKGlassGroup<Content: View>: View {
    private let spacing: CGFloat?
    private let content: Content

    public init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        if #available(iOS 26, macOS 26, *) {
            GlassEffectContainer(spacing: spacing) { content }
        } else {
            content
        }
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
