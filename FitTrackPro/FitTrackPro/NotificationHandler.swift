//
//  NotificationHandler.swift
//  FitTrackPro
//
//  Created by David Navarro on 7/10/24.
//

import Foundation
import UserNotifications

class NotificationHandler {
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Access Granted!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification(date: Date, type: String, timeInterval: Double = 10, title: String, body: String) {
        var trigger: UNNotificationTrigger?
        
        if type == "date" {
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        } else if type == "time" {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }
        
        let content = UNMutableNotificationContent()    // we make create this instance to modify the following
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        // request for the notification to go through
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) // add the request
    }
}
