import SwiftUI

public struct HKRowLabel<Title: View>: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    private let systemImage: String
    private let title: Title

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

#Preview("Interview row") {
    List {
        HKRowLabel(systemImage: "calendar") {
            Text("Interview")
        }
    }
    .environment(HKThemeManager(defaults: nil))
}
