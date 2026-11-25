import HKDesignSystem
import SwiftUI

/// Information about the app, presented as a sheet from settings.
struct AboutView: View {
    let onClose: () -> Void

    var body: some View {
        ContentUnavailableView(
            "HireKit",
            systemImage: "briefcase.fill",
            description: Text("Tu compañero en cada proceso de contratación.")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Acerca de")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Listo", action: onClose)
            }
        }
        .hkBackground()
    }
}
