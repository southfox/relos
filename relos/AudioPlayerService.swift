//
//  AudioPlayerService.swift
//  relos
//
//  Created by Javier Fuchs on 26/07/2025.
//

import Foundation
import AVFoundation

class AudioPlayerService: NSObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    
    func stop() {
        audioPlayer?.stop()
    }
    
    // Play a sound from a URL with a volume level (0–10)
    func playSound(from url: URL, volumeLevel: Int) {
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
            print("❌ Failed to play audio: \(error.localizedDescription)")
        }
    }
    
    // MARK: - AVAudioPlayerDelegate methods

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(flag ? "✅ Finished playing successfully." : "⚠️ Finished playing with error.")
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("❌ Decode error: \(error.localizedDescription)")
        }
    }
}
