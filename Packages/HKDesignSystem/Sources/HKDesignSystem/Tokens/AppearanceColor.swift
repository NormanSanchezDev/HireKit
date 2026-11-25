import SwiftUI

/// A shape style that resolves a color in a fixed appearance while keeping the
/// caller's contrast and other environment settings.
struct AppearanceColor: ShapeStyle, Hashable {
    let base: Color
    let scheme: ColorScheme

    func resolve(in environment: EnvironmentValues) -> Color.Resolved {
        var values = environment
        values.colorScheme = scheme
        return base.resolve(in: values)
    }
}
