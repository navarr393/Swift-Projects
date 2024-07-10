//
//  ContentView.swift
//  FitTrackPro
//
//  Created by David Navarro on 6/25/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Workout.name), SortDescriptor(\Workout.muscle)]) var workouts: [Workout]
    
    @State private var showingAddScreen = false
    @State private var showingReminderScreen = false
    
    private var groupedWorkouts: [String: [Workout]] {
        Dictionary(grouping: workouts, by: { $0.bodyPart })
    }
    
    var body: some View {
        NavigationStack {
            if workouts.isEmpty {
                VStack(alignment: .center) {
                    Text("You currently have no workouts.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .italic()
                    Text("Let's start by adding your first workout!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .italic()
                }
                .frame(height: 500)
            }
            List {
                ForEach(groupedWorkouts.keys.sorted(), id: \.self) { bodyPart in
                    if let bodyPartWorkouts = groupedWorkouts[bodyPart] {
                        Section {
                            ForEach(bodyPartWorkouts) { workout in
                                NavigationLink(value: workout) {
                                    HStack {
                                        Image(workout.bodyPart)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .clipShape(
                                                .rect(cornerRadius: 5)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(.black, lineWidth: 1)
                                            )
                                        VStack(alignment: .leading) {
                                            Text(workout.name)
                                                .font(.headline)
                                            
                                            Text("Added: \(workout.date.formatted(date: .complete, time: .omitted))")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                            
                        } header: {
                            Text(bodyPart)
                        }
                    }
                }
                .onDelete(perform: deleteWorkouts)
            }
            .navigationTitle("Workouts")
            .navigationDestination(for: Workout.self) { workout in
                    DetailView(workout: workout)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Workout", systemImage: "plus") {
                        showingAddScreen = true
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reminder", systemImage: "bell") {
                        // call ReminderView() using a sheet.
                        showingReminderScreen = true
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddWorkoutView()
            }
            .sheet(isPresented: $showingReminderScreen) {
                ReminderView()
            }
        }
    }
    
    func deleteWorkouts(at offsets: IndexSet) {
        for  offset in offsets {
            let workout = workouts[offset]
            modelContext.delete(workout)
        }
    }
}

#Preview {
    ContentView()
}
