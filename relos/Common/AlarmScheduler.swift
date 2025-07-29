//
//  AlarmScheduler.swift
//  relos
//
//  Created by Javier Fuchs on 29/07/2025.
//

import Foundation
import AVFoundation

class AlarmScheduler {
    let item: Item

    private var timer: Timer?
    private var lastError: NSError?
    private let audioService = AudioPlayerService()

    init(item: Item) {
        self.item = item
    }

    func schedule() {
        let timeInterval = item.timestamp.timeIntervalSinceNow
        guard timeInterval > 0 else {
            print("Alarm time is in the past for \(item.name)")
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
            self?.playAlarm()
        }
        print("Alarm scheduled for \(item.name) at \(item.timestamp)")
    }

    private func playAlarm() {
        print("Going to play alarm for \(item.name) at \(item.timestamp)")
        if let url = Bundle.main.url(forResource: item.sound, withExtension: nil) {
            do {
                print("Playing alarm for \(item.name) at \(item.timestamp)")
                try audioService.playSound(from: url, volumeLevel: Int(item.volume))
            } catch {
                print("Error playing alarm for \(item.name): \(error.localizedDescription)")
                lastError = error as NSError
            }
        }
    }

    func cancel() {
        timer?.invalidate()
        timer = nil
        print("Alarm cancelled for \(item.name)")
    }
}
