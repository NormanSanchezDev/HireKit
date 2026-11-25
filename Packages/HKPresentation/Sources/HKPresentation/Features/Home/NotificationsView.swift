import HKDesignSystem
import SwiftUI

/// The notifications screen, pushed from the dashboard.
struct NotificationsView: View {
    var body: some View {
        ContentUnavailableView(
            "Sin notificaciones",
            systemImage: "bell.slash",
            description: Text("Te avisaremos cuando haya novedades en tus procesos.")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Notificaciones")
        .hkBackdrop()
    }
}
