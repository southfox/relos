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

    init(timestamp: Date = Date(), name: String = "", sound: String = "", volume: Double = 1.0, isEnabled: Bool = true, isSnooze: Bool = true) {
        self.timestamp = timestamp
        self.name = name
        self.sound = sound
        self.volume = volume
        self.isEnabled = isEnabled
        self.isSnooze = isSnooze
    }
}
