//
//  HabitGuru_2_0App.swift
//  HabitGuru 2.0
//
//  Created by David Navarro on 5/1/24.
//

import SwiftUI

@main
struct HabitGuru_2_0App: App {
    @StateObject var manager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
        }
        .modelContainer(for: Habit.self)
    }
}
