//
//  HireKitApp.swift
//  HireKit
//
//  Created by Norman Sánchez on 24/11/26.
//

import HireKitDesignSystem
import SwiftUI
import SwiftData

@main
struct HireKitApp: App {
    @State private var themeManager = HKThemeManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(themeManager)
                .preferredColorScheme(themeManager.selectedMode.colorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
}
