//
//  HomeView.swift
//  HabitGuru 2.0
//
//  Created by David Navarro on 6/12/24.
//

import SwiftUI
import SwiftData
import LocalAuthentication
import UserNotifications

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    @Environment(\.modelContext) var modelContext
    @Query var habits: [Habit]  // the array that stores the habits
    
    @State private var showingAddScreen = false
    @State private var date = Date.now.formatted(date: .complete, time: .omitted)
    
    @State private var isUnlocked = false
    @State private var showSplashScreen = true
    
    var totalCount: Int {
        habits.reduce(0) { $0 + $1.count }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("\(date)") {
                    if habits.isEmpty {
                        VStack(alignment: .leading) {
                            Text("You don't have any habits yet!")
                                .font(.headline)
                                .italic()
                                .foregroundStyle(.secondary)
                            Text("Let's get started by adding your first habit.")
                                .font(.subheadline)
                                .italic()
                                .foregroundStyle(.secondary)
                        }
                    }
                    ForEach(habits) { habit in
                        NavigationLink(value: habit) {
                            HStack {
                                Text(habit.name)
                                
                                Spacer()
                                
//                                        Text(habit.count >= 10 ? "🔥" : "")
//                                            .font(.system(size: 13))

                                Text(String(habit.count))
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
                    .onDelete(perform: deleteHabits)
                }
                Section("Habits Completed") {
                    HStack {
                        Text(String(totalCount))
                            .font(.headline)
                            .padding(5)
                            .frame(minWidth: 50)
                            .background(Color(red: 255/255, green: 215/255, blue: 0/255))
                            .foregroundStyle(.black)
                            .clipShape(.capsule)
                            .shadow(color: .black, radius: 2, x: 1, y: 1)
                        
                        Text(totalCount >= 20 ? "🔥" : "")
                        Text(totalCount >= 40 ? "🔥" : "")
                        Text(totalCount >= 60 ? "🔥" : "")
                        Text(totalCount >= 80 ? "🔥" : "")
                        Text(totalCount >= 100 ? "🔥" : "")
                    }
                }
            }
            .navigationTitle("HabitGuru")
            .navigationDestination(for: Habit.self) { habit in // _ lets us pass nothing so Swift wont complain
                DetailView(habit: habit)
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Habit", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddHabitView()
            }
        }
}
        
    func deleteHabits(at offsets: IndexSet) {   // delete NavigationLinks
        for offset in offsets {
            let habit = habits[offset]
            modelContext.delete(habit)
        }
    }
    
    // fucntion will return the color around the activity.count based on the users count for that specifc activity
    func color(for habit: Habit) -> Color {
        if habit.count < 3 {
             .red
        } else if habit.count < 10 {
             .orange
        } else if habit.count < 20 {
             .green
        } else if habit.count < 50 {
             .blue
        } else {
             .indigo
        }
    }
    
    // faceID so only the user has acess to their habits, and only they can modify them.
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your habits!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    
                }
            }
        } else {
            // no biometrics
        }
    }
    
//    func requestPermission() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//            if success {
//                print("All set!")
//                //schedulePermission()
//            } else if let error {
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    func schedulePermission() {
//        let content = UNMutableNotificationContent()
//        content.title = "Complete all your habits today!"
//        content.subtitle = "You don't want to lose your streak! 🔥"
//        content.sound = UNNotificationSound.default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 18_000, repeats: true)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request)
//    }

}

#Preview {
    HomeView()
}
