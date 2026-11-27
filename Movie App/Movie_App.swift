//
//  Movie_App.swift
//  Movie App
//
//  Created by Connor on 10/7/26.
//

import SwiftUI
import SwiftData

@main
struct Movie_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Title.self) // creates container that store title objects
    }
}
