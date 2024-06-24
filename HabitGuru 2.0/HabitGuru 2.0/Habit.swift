//
//  Habit.swift
//  HabitGuru 2.0
//
//  Created by David Navarro on 5/1/24.
//

import Foundation
import SwiftData

@Model
class Habit: ObservableObject {
    var name: String
    var purpose: String
    var count: Int
    var type: String
    var timeSpent: Double
    
    init(name: String, purpose: String, count: Int, type: String, timeSpent: Double) {
        self.name = name
        self.purpose = purpose
        self.count = count
        self.type = type
        self.timeSpent = timeSpent
    }
}
