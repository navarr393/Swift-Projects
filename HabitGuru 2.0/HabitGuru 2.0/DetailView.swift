//
//  DetailView.swift
//  HabitGuru 2.0
//
//  Created by David Navarro on 5/2/24.
//

import SwiftUI
import SwiftData
import Charts
import UserNotifications

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    @State private var showingResetAlert = false
    @State private var showingNotifyAlert = false
    @State private var canTapButton = true
    @State private var timeSpent = 0.0
    @State private var selectedDate = Date()
    let notify = NotificationHandler()

    
    @ObservedObject var habit: Habit
    
    @State private var animationAmount = 0.0
    
    var body: some View {
        List {
            if habit.purpose.isEmpty == false {
                Section("My purpose") {
                    Text(habit.purpose)
                }
            }
            Section("Monthly count") {
                Text("\(habit.count)")
                    .font(.headline)
                
                Button(action: {
                    if canTapButton {
                        tapButton()
                        habit.count += 1
                    }
                }) {
                    Text("Mark Completed")
                        //.foregroundStyle(canTapButton ? .blue : .gray)
                    }
                    //.disabled(!canTapButton)    // disable the button if it cant be tapped.
                    .sensoryFeedback(.success, trigger: habit.count) // vibrates when the count changes
            }
            
            Section("Total time spent on habit") {
                VStack(alignment: .leading, spacing: 0) {
                    Stepper("\(habit.timeSpent.formatted()) hours", value: $habit.timeSpent, in: 0...100, step: 0.25)
                        .sensoryFeedback(.increase, trigger: habit.timeSpent)
                }
            }
            
            Section("Set Reminder") {   // button to notify the user to complete a specific habit if pressed will display an alert confirming the notification based on the date they scheduled
                DatePicker("Select Date:", selection: $selectedDate, in: Date()...) // only future dates
                Button("Remind Me") {
                    if habit.type == "Fitness" {
                        showingNotifyAlert = true
                        notify.askPermission()  // ask for permission first
                        notify.sendNotification(
                            date: selectedDate,
                            type: "date",
                            title: "Time to move!",
                            body: "Keep up the momentum with your \"\(habit.name)\" habit today! 💪"
                        )
                    } else if habit.type == "Learning" {
                        showingNotifyAlert = true
                        notify.askPermission()  // ask for permission first
                        notify.sendNotification(
                            date: selectedDate,
                            type: "date",
                            title: "Expand your knowledge!",
                            body: "Don't forget to work on your \"\(habit.name)\" habit today! 📝"
                        )
                    } else if habit.type == "Productivity" {
                        showingNotifyAlert = true
                        notify.askPermission()  // ask for permission first
                        notify.sendNotification(
                            date: selectedDate,
                            type: "date",
                            title: "Stay productive!",
                            body: "Boost your productivity by completing your \"\(habit.name)\" habit today! ✅"
                        )
                    }
                }
                .alert("Success! 🙌", isPresented: $showingNotifyAlert) {
                    Button("OK") {
                        // empty body
                    }
                } message: {
                    Text("You will be notified to complete: \(habit.name)")
                }
            }
            
            Section {
                Button("Undo Count") {    // habit count decreases by one
                    if habit.count > 0 {    // prevents the user from going into negative count
                        habit.count -= 1
                    }
                }
                .sensoryFeedback(.decrease, trigger: habit.count)
                .foregroundStyle(.red)
                
                //Spacer()
            }
            Section {
                    Button("Reset Count") { // habit count resets to 0
                        showingResetAlert.toggle()
                    }
                    .confirmationDialog("Reset Habit Count", isPresented: $showingResetAlert) {
                        Button("Reset", role: .destructive, action: resetCount)
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Reset your monthly count to 0?")
                    }
                    .sensoryFeedback(.warning, trigger: habit.count)
                    .foregroundStyle(.red)
            }
        }
        .navigationTitle(habit.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Delete Habit", systemImage: "trash") {
                showingDeleteAlert = true
            }
            .confirmationDialog("Delete Habit", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive, action: deleteHabit)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this Habit?")
            }
        }
    }
    // func to delete the book from  this view
    func deleteHabit() {
        modelContext.delete(habit)
        dismiss()
    }
    
    func resetCount() {
        habit.count = 0
    }
    
    func tapButton() {
        canTapButton = false
        storeCurrentDate()
    }
    
    func storeCurrentDate() {
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: "lastTapDate")
    }
    
    func checkLastTapDate() {
        if let lastTapDate = UserDefaults.standard.object(forKey: "lastTapDate") as? Date {
            let calendar = Calendar.current
            if calendar.isDateInToday(lastTapDate) {
                // the button was tapped today so disable it
                canTapButton = false
                
            } else {
                // button was not tapped today so enable it
                canTapButton = true
            }
        } else {
            // no record of tap so enbale the button
            canTapButton = true
        }
    }
//  another way to send notifications: sends at the specified dateComponents.hour, .minute, .seconds etc
//    func addNotification() {
//        let center = UNUserNotificationCenter.current()
//        
//        let addRequest = {
//            let content = UNMutableNotificationContent()
//            content.title = "Habit Reminder"
//            content.subtitle = "Don't lose your \(habit.name) streak! 🔥"
//            content.sound = UNNotificationSound.default
//            
//            var dateComponents = DateComponents()
//            dateComponents.hour = 20
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//            
//            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//            center.add(request)
//            
//        }
//        // ask the user for permissions
//        center.getNotificationSettings { settings in
//            if settings.authorizationStatus == .authorized {
//                addRequest()
//            } else {
//                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                    if success {
//                        addRequest()
//                    } else if let error {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//    }
}

    

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        let example = Habit(name: "Running", purpose: "Half Marathon Training", count: 0, type: "Fitness", timeSpent: 0.0)
        
        return DetailView(habit: example)
            .modelContainer(container)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
