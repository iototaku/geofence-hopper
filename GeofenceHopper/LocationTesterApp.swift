//
//  GeofenceHopperApp.swift
//  GeofenceHopper
//
//  Created by Takano Masanori on 2023/09/29.
//

import SwiftUI
import SwiftData

@main
struct GeofenceHopperApp: App {
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }.modelContainer(container)
    }
    
    init() {
        do {
            container = try ModelContainer(for: LocationHistory.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
}
