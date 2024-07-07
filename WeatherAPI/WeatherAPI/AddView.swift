//
//  AddView.swift
//  WeatherAPI
//
//  Created by David Navarro on 7/5/24.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var cityName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter City", text: $cityName)
            }
            .navigationTitle("Add City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "square.and.arrow.down") {
                        let location = Location(city: cityName)
                        modelContext.insert(location)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    AddView()
}
