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
    
    init(timestamp: Date = Date(), name: String = "Sample Item", sound: String = "Default", volume: Double = 1.0) {
        self.timestamp = timestamp
        self.name = name
        self.sound = sound
        self.volume = volume
    }
}
