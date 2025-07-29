//
//  Item.swift
//  relos
//
//  Created by Javier Fuchs on 26/07/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var name: String
    var sound: String
    var volume: Double
    var isEnabled: Bool = true
    var isSnooze: Bool = true
    var snoozeDuration: Int

    init(timestamp: Date = Date().truncatedToMinute, name: String = "", sound: String = "", volume: Double = Item.volumeDefault, isEnabled: Bool = true, isSnooze: Bool = true, snoozeDuration: Int = Item.snoozeDurationDefault) {
        self.timestamp = timestamp
        self.name = name
        self.sound = sound
        self.volume = volume
        self.isEnabled = isEnabled
        self.isSnooze = isSnooze
        self.snoozeDuration = snoozeDuration
    }
}

extension Item {
    static let limit: Int = Item.limit
    static let snoozeDurationDefault: Int = 5
    static let volumeDefault: Double = 1.0
    static let snoozeArray = Array(1...15)
}

extension Array where Element == Item {
    func createUniqueItem(with text: String) -> Item {
        var name = ""
        var i = 0
        repeat {
            i = i + 1
            name = "\(text) #\(self.count + i)"
        } while self.contains(where: { $0.name == name })
        let newItem = Item(name: name)
        return newItem
    }
}

extension Date {
    var truncatedToMinute: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let truncatedDate = calendar.date(from: components)!
        return truncatedDate
    }
}
