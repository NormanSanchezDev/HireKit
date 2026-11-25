import HKDesignSystem
import SwiftUI

/// Information about the app, presented as a sheet from settings.
struct AboutView: View {
    let onClose: () -> Void

    var body: some View {
        ContentUnavailableView(
            "about_title_txt",
            systemImage: "briefcase.fill",
            description: Text("about_description_txt")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("about_navigation_title_txt")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("common_done", action: onClose)
            }
        }
        .hkBackground()
    }
}
