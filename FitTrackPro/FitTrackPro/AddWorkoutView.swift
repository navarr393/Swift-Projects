//
//  AddWorkoutView.swift
//  FitTrackPro
//
//  Created by David Navarro on 6/25/24.
//

import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var muscle = ""
    @State private var bodyPart = ""
    
    let muscleTypes = ["Chest", "Core", "Legs", "Arms", "Back", "Shoulders", "Cardio"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Workout Name", text: $name)
                    TextField("Target Muscle", text: $muscle)
                    
                    Picker("Body Part", selection: $bodyPart) {
                        ForEach(muscleTypes, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section {
                    Button("Save") {
                        let newWorkout = Workout(name: name, muscle: muscle, bodyPart: bodyPart, date: .now, sets: 0, weight: 0)
                        modelContext.insert(newWorkout)
                        dismiss()
                    }
                }
                .disabled(name.isEmpty || muscle.isEmpty)
            }
            .navigationTitle("Add Workout")
        }
    }
}

#Preview {
    AddWorkoutView()
}
