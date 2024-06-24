//
//  HealthManager.swift
//  HabitGuru 2.0
//
//  Created by David Navarro on 6/21/24.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())    // current date and time.
    }
}

extension Date {
    static var startOfWeek: Date? {
        let calendar = Calendar.current
        let currentDate = Date()
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: currentDate) else { return nil }
        return weekInterval.start
    }
}
extension Double {  // convert a bouble to a string
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    @Published var activities: [String : Activity] = [:]    // this is a dictionary value String and key Activity
    @Published var mockActivities: [String : Activity] = [
        "todaySteps" : Activity(id: 10, title: "Daily steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: "6000"),
        "todayClaories" : Activity(id: 1, title: "Daily claories", subtitle: "Goal: 1,000", image: "flame", amount: "600")
    ]
    
    init() {
        //  ask for access for the folowing activities
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        let healthTypes: Set = [steps, calories, workout]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchWeekRunningStats()
                fetchWeekStrenghtTrainingStats()
            } catch {
                print("Error fetching health data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)  // storing users steps in steps
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching todays step data.")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Today steps", subtitle: "Goal 10,000", image: "figure.walk", amount: stepCount.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todaySteps"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    func fetchTodayCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)  // storing users steps in steps
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching todays calorie data.")
                return
            }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Today calories", subtitle: "Goal 900", image: "flame", amount: caloriesBurned.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todayCalories"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    func fetchWeekRunningStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 25, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("Error fetching weekly running data.")
                return
            }
            var count: Int = 0
            for workout in workouts {
                let duration = Int(workout.duration)/60
                count += duration
//                print(workout.allStatistics)
//                print(Int(workout.duration)/60)
//                print(workout.workoutActivityType)
            }
            let activity = Activity(id: 2, title: "Running", subtitle: "Mins this week", image: "figure.run", amount: "\(count) minutes")
            
            DispatchQueue.main.async {
                self.activities["weekRunning"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    func fetchWeekStrenghtTrainingStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .traditionalStrengthTraining)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 25, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("Error fetching weekly strenght training data.")
                return
            }
            var count: Int = 0
            for workout in workouts {
                let duration = Int(workout.duration)/60
                count += duration

            }
            let activity = Activity(id: 3, title: "Traditional Strenght Training", subtitle: "Mins this week", image: "dumbbell", amount: "\(count) minutes")
            
            DispatchQueue.main.async {
                self.activities["weekStrenght"] = activity
            }
        }
        healthStore.execute(query)
    }
}
