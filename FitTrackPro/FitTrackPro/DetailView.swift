//
//  DetailView.swift
//  FitTrackPro
//
//  Created by David Navarro on 6/25/24.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    @ObservedObject var workout: Workout
    
    var body: some View {
        // add pictures here
        List {
            //                ZStack(alignment: .bottomTrailing) {
            //                    Image(workout.bodyPart)
            //                        .resizable()
            //                        .scaledToFit()
            //
            //
            //                    Text(workout.bodyPart.uppercased())
            //                        .fontWeight(.black)
            //                        .padding(8)
            //                        .foregroundStyle(.white)
            //                        .background(.black.opacity(0.75))
            //                        .clipShape(.capsule)
            //                        .offset(x: -5, y: -5)
            //                }
            VStack(alignment: .leading) {
                Text(workout.name)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.primary)
                
                Text("Main Body Part: \(workout.bodyPart)")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                Text("Targets: \(workout.muscle)")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                Text("You added this workout: \(workout.date.formatted(date: .complete, time: .omitted))")
                    .italic()
                    .foregroundStyle(.secondary)
            }
            if workout.bodyPart == "Cardio" {
                Section("Minutes") {
                    Stepper("Minutes: ", value: $workout.weight, in: 1...500, step: 5)
                        .font(.headline)
                }
            } else {
                Section("Number of sets") {
                    Stepper("Sets: \(workout.sets)", value: $workout.sets, in: 0...500, step: 1)
                        .font(.headline)
                }
                
                Section("Max Weight") {
                    Stepper("Weight: \(workout.weight)", value: $workout.weight, in: 0...500, step: 5)
                        .font(.headline)
                }
            }
        }
//        .navigationTitle(workout.name)
//        .navigationBarTitleDisplayMode(.inline)
//        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete Workout", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteWorkout)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this workout?")
        }
        .toolbar {
            Button("Delete this workout", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
    }
    
    func deleteWorkout() {
        modelContext.delete(workout)
        dismiss()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, configurations: config)
        let example = Workout(name: "Chest Press", muscle: "Chest", bodyPart: "Chest", date: .now, sets: 0, weight: 0)
        
        return DetailView(workout: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
