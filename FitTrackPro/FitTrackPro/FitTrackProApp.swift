//
//  FitTrackProApp.swift
//  FitTrackPro
//
//  Created by David Navarro on 6/25/24.
//

import SwiftUI

@main
struct FitTrackProApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Workout.self)
    }
}
