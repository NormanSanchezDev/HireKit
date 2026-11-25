//
//  ContentView.swift
//  HireKit
//
//  Created by Norman Sánchez on 24/11/26.
//

import HireKitDesignSystem
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(HKThemeManager.self) private var themeManager
    @Query private var items: [Item]

    var body: some View {
        @Bindable var themeManager = themeManager

        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        HireKitRowLabel(systemImage: "calendar") {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Appearance", selection: $themeManager.selectedMode) {
                            Text("System").tag(HKThemeMode.system)
                            Text("Light").tag(HKThemeMode.light)
                            Text("Dark").tag(HKThemeMode.dark)
                        }
                    } label: {
                        Label("Appearance", systemImage: "circle.lefthalf.filled")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            HKLabel(model: .init(text: "Select an item"))
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(HKThemeManager(defaults: nil))
        .modelContainer(for: Item.self, inMemory: true)
}
