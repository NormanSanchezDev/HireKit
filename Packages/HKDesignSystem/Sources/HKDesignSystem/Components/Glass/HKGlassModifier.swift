import SwiftUI

extension View {
    /// Places a design system Liquid Glass material behind this view.
    ///
    /// Use it to build custom glass controls that match the rest of the design
    /// system. For grouped content, prefer ``HKGlassCard``.
    ///
    /// ```swift
    /// Label("Remote", systemImage: "house")
    ///     .padding()
    ///     .hkGlass(.tinted(.teal), in: .capsule)
    /// ```
    ///
    /// - Parameters:
    ///   - style: The glass material to use.
    ///   - isInteractive: Whether the glass reacts to touch and pointer input.
    ///     Set it only when the view itself is tappable.
    ///   - shape: The shape of the glass.
    /// - Returns: A view with a Liquid Glass background in the given shape.
    public func hkGlass(
        _ style: HKGlassStyle = .regular,
        isInteractive: Bool = false,
        in shape: some Shape = .capsule
    ) -> some View {
        glassEffect(style.glass(isInteractive: isInteractive), in: shape)
    }
}

#Preview("Glass styles") {
    HKGlassGroup(spacing: 12) {
        VStack(spacing: 12) {
            Label("common_regular_glass", systemImage: "drop")
                .padding()
                .hkGlass()
            Label("common_clear_glass", systemImage: "drop.halffull")
                .padding()
                .hkGlass(.clear)
            Label("common_tinted_glass", systemImage: "drop.fill")
                .padding()
                .hkGlass(.tinted(.indigo), isInteractive: true)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .hkBackground()
    .environment(HKThemeManager(defaults: nil))
}
