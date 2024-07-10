//
//  Workout.swift
//  FitTrackPro
//
//  Created by David Navarro on 6/25/24.
//

import Foundation
import SwiftData

@Model
class Workout: ObservableObject {
    var name: String
    var muscle: String
    var bodyPart: String
    var date: Date
    var sets: Int
    var weight: Int
    
    init(name: String, muscle: String, bodyPart: String, date: Date, sets: Int, weight: Int) {
        self.name = name
        self.muscle = muscle
        self.bodyPart = bodyPart
        self.date = date
        self.sets = sets
        self.weight = weight
    }
}
