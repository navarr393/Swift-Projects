//
//  WeatherAPIApp.swift
//  WeatherAPI
//
//  Created by David Navarro on 7/3/24.
//

import SwiftUI

@main
struct WeatherAPIApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
        .modelContainer(for: Location.self)
    }
}
