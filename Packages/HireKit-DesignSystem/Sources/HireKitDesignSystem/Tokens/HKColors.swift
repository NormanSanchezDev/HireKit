import SwiftUI

public struct HKColors: Sendable {
    let colorScheme: ColorScheme?

    public var primary: Color { themed(.indigo) }
    public var secondary: Color { themed(.teal) }
    public var textPrimary: Color { themed(.primary) }
    public var textSecondary: Color { themed(.secondary) }
    public var success: Color { themed(.green) }
    public var warning: Color { themed(.orange) }
    public var error: Color { themed(.red) }

    #if os(macOS)
    public var background: Color { themed(Color(nsColor: .windowBackgroundColor)) }
    public var surface: Color { themed(Color(nsColor: .controlBackgroundColor)) }
    public var border: Color { themed(Color(nsColor: .separatorColor)) }
    #else
    public var background: Color { themed(Color(uiColor: .systemBackground)) }
    public var surface: Color { themed(Color(uiColor: .secondarySystemBackground)) }
    public var border: Color { themed(Color(uiColor: .separator)) }
    #endif

    private func themed(_ color: Color) -> Color {
        guard let colorScheme else { return color }
        return Color(AppearanceColor(base: color, scheme: colorScheme))
    }
}

/// Preserve the caller’s contrast and other environment settings when overriding appearance.
private struct AppearanceColor: ShapeStyle, Hashable {
    let base: Color
    let scheme: ColorScheme

    func resolve(in environment: EnvironmentValues) -> Color.Resolved {
        var values = environment
        values.colorScheme = scheme
        return base.resolve(in: values)
    }
}
