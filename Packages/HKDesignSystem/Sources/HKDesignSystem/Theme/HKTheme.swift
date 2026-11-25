import SwiftUI

public struct HKTheme: Sendable {
    public let colors: HKColors
    public let typography = HKTypography()
    public let spacing = HKSpacing()
    public let radius = HKRadius()

    init(colorScheme: ColorScheme?) {
        colors = HKColors(colorScheme: colorScheme)
    }
}
