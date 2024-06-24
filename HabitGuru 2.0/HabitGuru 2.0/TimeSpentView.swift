//
//  TimeSpentView.swift
//  HabitGuru 2.0
//
//  Created by David Navarro on 6/11/24.
//

import SwiftUI
import SwiftData
import Charts

struct TimeSpentView: View {
    @Environment(\.modelContext) var modelContext
    let habits: [Habit]
    
    var totalHours: Double {    // add all the habit.timeSpent
        habits.reduce(0) { $0 + $1.timeSpent }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Hours Logged") {
                    if habits.isEmpty {
                        VStack(alignment: .leading) {
                            Text("You don't have any habits yet!")
                                .font(.headline)
                                .italic()
                                .foregroundStyle(.secondary)
                            Text("Add a habit to track your hours.")
                                .font(.subheadline)
                                .italic()
                                .foregroundStyle(.secondary)
                        }
                    }
                    ForEach(habits) { habit in
                        HStack {
                            Text(habit.name)
                            
                            Spacer()
                            
                            Text("hrs: ")
                                .italic()
                            
                            Text(String(habit.timeSpent))
                                .font(.caption.weight(.black))
                                .padding(5)
                                .frame(minWidth: 50)
                                .background(color(for: habit))
                                .foregroundStyle(.white)
                                .clipShape(.capsule)
                                .shadow(color: .black, radius: 2, x: 1, y: 1)
                        }
                    }
                }
                
                Section("Hours Being Productive") {
                    Text(String(totalHours))
                        .font(.headline)
                        .padding(5)
                        .frame(minWidth: 50)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                        .shadow(color: .black, radius: 2, x: 1, y: 1)
                }
                
                Section("Daily Average Productivity") {
                    Text("\(formattedDailyAverageProductivity()) hrs")
                        .font(.headline)
                        .padding(5)
                        .frame(minWidth: 50)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                        .shadow(color: .black, radius: 2, x: 1, y: 1)
                }
            }
            .navigationTitle("Time Overview")
        }
    }
    
    // fucntion will return the color around the habit.timeSpent based on the users count for that specifc activity
    
    func color(for habit: Habit) -> Color {
        if habit.timeSpent < 3 {
            return .gray
        } else if habit.timeSpent < 5 {
            return .yellow
        } else if habit.timeSpent < 10 {
            return .green
        } else if habit.timeSpent < 20 {
            return .teal
        } else {
            return .purple
        }
    }
    // return the total days in current month to calculate the average daily productivity
    func daysInCurrentMonth() -> Int {
        let calendar = Calendar.current
        let date = Date()
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count ?? 30 // Default to 30 if unable to determine
    }
    // calculate the daily average
    func formattedDailyAverageProductivity() -> String {
        let totalDays = daysInCurrentMonth()
        let dailyAverage = totalHours / Double(totalDays)
        return String(format: "%.2f", dailyAverage)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        
        // create an example
        let example = [Habit(name: "Run", purpose: "Marathon", count: 5, type: "Fitness", timeSpent: 3.0), Habit(name: "Gym", purpose: "Marathon", count: 5, type: "Fitness", timeSpent: 9.0)]
        
        //example.forEach { container.insert($0) }
        
        return TimeSpentView(habits: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create view: \(error.localizedDescription)")
    }
}
