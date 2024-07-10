//
//  ReminderView.swift
//  FitTrackPro
//
//  Created by David Navarro on 7/10/24.
//

import SwiftUI

struct ReminderView: View {
    @State private var selectDate = Date()
    @State private var showingNotificationAlert = false
    
    let notify = NotificationHandler()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Remind me to workout") {
                    DatePicker("Select time:", selection: $selectDate, in: Date()...)
                    Button("Set Reminder") {
                        showingNotificationAlert = true
                        notify.askPermission()
                        notify.sendNotification(date: selectDate, type: "date", title: "Time to move!", body: "Keep up the momentum get that workout in today! 💪")
                    }
                    .alert("Success!", isPresented: $showingNotificationAlert) {
                        Button("OK") {
                            // empty body
                        }
                    } message: {
                        Text("You will be reminded to workout!")
                    }
                }
            }
            .navigationTitle("Reminder")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ReminderView()
}
