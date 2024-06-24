//
//  ContentView.swift
//  HabitGuru 2.0
//
//  Created by David Navarro on 5/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // this will add a gray backgound to the tab bar
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemGray5
    }
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var manager: HealthManager
    @Query var habits: [Habit]  // the array that stores the habits
    
    @State private var showSplashScreen = true

    
    var body: some View {
        ZStack {
            if showSplashScreen {
                SplashScreenView()
                    .transition(.opacity)
                    .animation(.easeInOut, value: 1.5)
            } else {
                VStack {
                    TabView {
                        HomeView()
                            .tabItem {
                                Label("Habits", systemImage: "pencil.and.list.clipboard")
                            }
                        TimeSpentView(habits: habits)
                            .tabItem {
                                Label("Productivity", systemImage: "clock.badge.questionmark")
                            }
                        GraphsView(habits: habits)
                            .tabItem {
                                Label("Analytics", systemImage: "chart.line.uptrend.xyaxis")
                            }
                        DisplayActivityCardView()
                            .tabItem {
                                Label("Activity", systemImage: "figure.run")
                            }
                            .environmentObject(manager)
                        
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.showSplashScreen = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
