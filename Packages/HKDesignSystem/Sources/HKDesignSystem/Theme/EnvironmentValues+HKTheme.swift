import SwiftUI

extension EnvironmentValues {
    /// The HireKit theme that design system components and app views read.
    ///
    /// It has a default value, so views and previews work without injecting it.
    @Entry public var hkTheme = HKTheme()
}
