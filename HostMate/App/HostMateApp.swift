//
//  HostMateApp.swift
//  HostMate
//
//  Created by Paul Ancajima on 8/6/25.
//

import SwiftUI
import SwiftData

@main
struct HostMateApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Listing.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    init() {
        // Path to SwiftData file, default.store. We use this file in our sqlite gui database application.
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
    }
}
