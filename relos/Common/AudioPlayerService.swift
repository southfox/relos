//
//  AudioPlayerService.swift
//  relos
//
//  Created by Javier Fuchs on 26/07/2025.
//

import Foundation
import AVFoundation

/// TBD: migrate to Combine
class AudioPlayerService: NSObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    private var lastError: NSError?
    
    var mp3Files: [String] {
        guard let resourcePath = Bundle.main.resourcePath else { return [] }
        let resourceURL = URL(fileURLWithPath: resourcePath)
        let files = (try? FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil)) ?? []
        var list = files
            .filter { $0.pathExtension.lowercased() == "mp3" }
            .map { $0.lastPathComponent }
            .sorted()
        list.insert("Default.mp3", at: 0)
        return list
    }
    
    var firstMp3File: String! {
        mp3Files.first
    }

    func stop() {
        audioPlayer?.stop()
    }
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying == true
    }
    
    // Play a sound from a URL with a volume level (0–10)
    func playSound(from url: URL, volumeLevel: Int) throws {
        do {
            if let audioPlayer = audioPlayer {
                audioPlayer.delegate = nil
                audioPlayer.stop()
            }
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.volume = Float(volumeLevel) / 10.0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("🔊 Playing sound with volume: \(volumeLevel)/10")
        } catch {
            lastError = error as NSError
            throw error
        }
    }
    
    // MARK: - AVAudioPlayerDelegate methods
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(flag ? "✅ Finished playing successfully." : "⚠️ Finished playing with error.")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            lastError = error as NSError
            print("❌ Decode error: \(error.localizedDescription)")
        }
    }
}
