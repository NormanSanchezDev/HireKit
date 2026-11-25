import SwiftUI

/// A screen background of hand-drawn doodles that drift slowly over a solid
/// theme color.
///
/// The doodles mix line drawings with hiring symbols, such as a briefcase or a
/// résumé, stroked in the theme's primary, secondary and neutral colors at low
/// opacity. They give Liquid Glass surfaces color and texture to refract
/// without gradients. Put the background behind screens that are mostly glass,
/// usually with the `hkBackground()` modifier:
///
/// ```swift
/// ScrollView { ... }
///     .hkBackground()
/// ```
///
/// The background adapts to light and dark appearance, holds still when
/// Reduce Motion is on, extends under the safe areas and is hidden from
/// accessibility.
public struct HKBackground: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var startDate = Date.now
    @State private var doodles: [HKDoodle] = []

    private let field = HKDoodleField()

    /// Creates a background that follows the active theme.
    public init() {}

    public var body: some View {
        let theme = themeManager.current(for: colorScheme)
        let isDark = (themeManager.selectedMode.colorScheme ?? colorScheme) == .dark
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: reduceMotion)) { timeline in
            Canvas { context, _ in
                context.opacity = isDark ? 0.3 : 0.22
                let time = reduceMotion ? 0 : timeline.date.timeIntervalSince(startDate)
                for doodle in doodles {
                    draw(doodle, in: context, at: time, colors: theme.colors)
                }
            }
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { size in
                doodles = field.doodles(in: size)
            }
        }
        .background(theme.colors.background)
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

    private func draw(_ doodle: HKDoodle, in context: GraphicsContext, at time: TimeInterval, colors: HKColors) {
        var context = context
        context.concatenate(doodle.transform(at: time))
        let color = color(for: doodle.tint, in: colors)
        if let symbolName = doodle.kind.symbolName {
            var image = context.resolve(Image(systemName: symbolName))
            image.shading = .color(color)
            context.draw(image, in: fittedRect(for: image.size, side: doodle.size))
        } else {
            let side = doodle.size
            context.stroke(
                doodle.kind.path(in: CGRect(x: -side / 2, y: -side / 2, width: side, height: side)),
                with: .color(color),
                style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round)
            )
        }
    }

    private func fittedRect(for imageSize: CGSize, side: CGFloat) -> CGRect {
        let scale = side / max(imageSize.width, imageSize.height, 1)
        let width = imageSize.width * scale
        let height = imageSize.height * scale
        return CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
    }

    private func color(for tint: HKDoodle.Tint, in colors: HKColors) -> Color {
        switch tint {
        case .primary: colors.primary
        case .secondary: colors.secondary
        case .neutral: colors.textSecondary
        }
    }
}

extension View {
    /// Places the HireKit doodle background behind this view, edge to edge.
    ///
    /// - Returns: A view with ``HKBackground`` as its background.
    public func hkBackground() -> some View {
        background { HKBackground() }
    }
}

#Preview("Claro") {
    HKGlassCard {
        HKLabel("welcome_title_txt", type: .title, tone: .accent)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .hkBackground()
    .environment(HKThemeManager(defaults: nil))
    .preferredColorScheme(.light)
}

#Preview("Oscuro") {
    HKGlassCard {
        HKLabel("welcome_title_txt", type: .title, tone: .accent)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .hkBackground()
    .environment(HKThemeManager(defaults: nil))
    .preferredColorScheme(.dark)
}
