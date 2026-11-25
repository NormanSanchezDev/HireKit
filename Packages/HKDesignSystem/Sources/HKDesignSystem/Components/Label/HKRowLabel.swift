import SwiftUI

/// A list row label with an SF Symbol in the brand color.
///
/// Use it inside `List`, `Form` and buttons that look like rows:
///
/// ```swift
/// Button(action: openAppearance) {
///     HKRowLabel("Apariencia", systemImage: "paintpalette")
/// }
/// ```
public struct HKRowLabel<Title: View>: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    private let systemImage: String
    private let title: Title

    /// Creates a row label with a custom title view.
    ///
    /// - Parameters:
    ///   - systemImage: The name of the SF Symbol to show.
    ///   - title: The title of the row.
    public init(systemImage: String, @ViewBuilder title: () -> Title) {
        self.systemImage = systemImage
        self.title = title()
    }

    public var body: some View {
        Label {
            title
        } icon: {
            Image(systemName: systemImage)
                .foregroundStyle(themeManager.current(for: colorScheme).colors.primary)
        }
    }
}

extension HKRowLabel where Title == Text {
    /// Creates a row label with a localized title.
    ///
    /// - Parameters:
    ///   - title: The localized title of the row.
    ///   - systemImage: The name of the SF Symbol to show.
    public init(_ title: LocalizedStringKey, systemImage: String) {
        self.init(systemImage: systemImage) { Text(title) }
    }
}

#Preview("Rows") {
    List {
        HKRowLabel("Interview", systemImage: "calendar")
        HKRowLabel(systemImage: "person.2") {
            Text("Hiring team")
        }
    }
    .environment(HKThemeManager(defaults: nil))
}
