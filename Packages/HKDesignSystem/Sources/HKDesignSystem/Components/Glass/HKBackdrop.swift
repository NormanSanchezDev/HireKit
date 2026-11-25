import SwiftUI

/// A soft brand gradient that gives Liquid Glass surfaces color to refract.
///
/// Glass over a flat background looks gray. Put the backdrop behind screens
/// that are mostly glass, usually with the `hkBackdrop()` modifier:
///
/// ```swift
/// ScrollView { ... }
///     .hkBackdrop()
/// ```
///
/// The backdrop is decorative, extends under the safe areas and is hidden from
/// accessibility.
public struct HKBackdrop: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    /// Creates a backdrop that follows the active theme.
    public init() {}

    public var body: some View {
        let colors = themeManager.current(for: colorScheme).colors
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [0.6, 0.4], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1],
            ],
            colors: [
                colors.primary.opacity(0.55), colors.background, colors.secondary.opacity(0.45),
                colors.background, colors.primary.opacity(0.25), colors.background,
                colors.secondary.opacity(0.35), colors.background, colors.primary.opacity(0.4),
            ]
        )
        .background(colors.background)
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

extension View {
    /// Places the HireKit backdrop behind this view, edge to edge.
    ///
    /// - Returns: A view with ``HKBackdrop`` as its background.
    public func hkBackdrop() -> some View {
        background { HKBackdrop() }
    }
}

#Preview("Backdrop") {
    HKBackdrop()
        .environment(HKThemeManager(defaults: nil))
}
