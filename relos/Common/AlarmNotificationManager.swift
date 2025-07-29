//
//  AlarmNotificationManager.swift
//  relos
//
//  Created by Javier Fuchs on 29/07/2025.
//

import Foundation
import UserNotifications

class AlarmNotificationManager {
    static let shared = AlarmNotificationManager()
    private init() {}

    // Schedule a notification alarm for an item
    func scheduleAlarm(for item: Item, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Alarm for \(item.name)"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: "\(item.id)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling alarm: \(error)")
            }
        }
    }

    // Cancel a scheduled alarm for an item
    func cancelAlarm(for item: Item) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(item.id)"])
    }

    // Cancel all scheduled alarms
    func cancelAllAlarms() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
