import HKDesignSystem
import SwiftUI

/// The notifications screen, pushed from the dashboard.
struct NotificationsView: View {
    var body: some View {
        ContentUnavailableView(
            "notifications_empty_title_txt",
            systemImage: "bell.slash",
            description: Text("notifications_empty_description_txt")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("notifications_title_txt")
        .hkBackground()
    }
}
