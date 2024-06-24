//
//  GraphsView.swift
//  HabitGuru 2.0
//
//  Created by David Navarro on 6/13/24.
//

import SwiftUI
import SwiftData
import Charts

struct GraphsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    let habits: [Habit]
    
    private var backgroundColor: Color {
        return colorScheme == .light ? Color(UIColor.systemGray6) : .black
    }
    var body: some View {
        NavigationStack {
            VStack {
                Chart {
                    ForEach(habits) { habit in
                        BarMark(x: .value("Time", habit.count),
                                y: .value("Time Spent", habit.timeSpent))
                        .annotation(position: .topTrailing) {
                            Text(String(habit.timeSpent))
                                .font(.system(size: 10))
                        }
                        .foregroundStyle(by: .value("Name", habit.name))
                    }
                }
                .padding()
            }
            .navigationTitle("Analytics")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
        }
    }
}
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        
        let example = [Habit(name: "Run", purpose: "Marathon", count: 5, type: "Fitness", timeSpent: 3.0),
                       Habit(name: "Gym", purpose: "Get Buff", count: 9, type: "Fitness", timeSpent: 11.0),
                       Habit(name: "Reading", purpose: "Improve Knowledge", count: 16, type: "Learning", timeSpent: 9.0)]
                       
        return GraphsView(habits: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to load view: \(error.localizedDescription)")
    }
}
