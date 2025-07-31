//
//  AlarmManager.swift
//  relos
//
//  Created by Javier Fuchs on 29/07/2025.
//

import Foundation

class AlarmManager {
    private var schedulers: [ObjectIdentifier: AlarmScheduler] = [:]

    // Schedule alarms for all enabled items
    func scheduleAlarms(for items: [Item]) {
        cancelAll()
        for item in items where item.isEnabled {
            scheduleAlarm(for: item)
        }
    }

    // Schedule a single alarm
    func scheduleAlarm(for item: Item) {
        cancelAlarm(for: item)
        let scheduler = AlarmScheduler(item: item)
        scheduler.schedule()
        schedulers[item.id] = scheduler
    }

    // Cancel a specific alarm
    func cancelAlarm(for item: Item) {
        schedulers[item.id]?.cancel()
        schedulers[item.id] = nil
    }

    // Cancel all alarms
    func cancelAll() {
        for (_, scheduler) in schedulers {
            scheduler.cancel()
        }
        schedulers.removeAll()
    }
}
