//
//  MyLibraryApp.swift
//  MyLibrary
//  


import SwiftUI
import SwiftData

@main
struct MyLibraryApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Book.self,
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
            ListView()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(BookViewModel())
    }
}
