//
//  AddHabitView.swift
//  HabitGuru 2.0
//
//  Created by David Navarro on 5/1/24.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var purpose = ""
    @State private var count = 0
    @State private var type = "Fitness"
    
    let habitTypes = ["Fitness", "Learning", "Productivity"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("New Habit", text: $name)
                    TextField("Your Goal", text: $purpose)
                    
                    Picker("Habit Type", selection: $type) {
                        ForEach(habitTypes, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .toolbar {
                Button("Save", systemImage: "square.and.arrow.down.on.square") {
                    let newHabit = Habit(name: name, purpose: purpose, count: count, type: type, timeSpent: 0.0)
                    modelContext.insert(newHabit)
                    dismiss()
                }
                .disabled((isEmptyText(name) || isEmptyText(purpose)))
            }
            .navigationTitle("Add Habit")
        }
    }
    
    // checl to see if the entry for habit name or purpose is empty checking for whitespaces and new lines
    func isEmptyText(_ text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    AddHabitView()
}
