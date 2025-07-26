import SwiftUI
import SwiftData
import AVFoundation

func getMP3Files() -> [String] {
    guard let resourcePath = Bundle.main.resourcePath else { return [] }
    let resourceURL = URL(fileURLWithPath: resourcePath)
    let files = (try? FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil)) ?? []
    return files
        .filter { $0.pathExtension.lowercased() == "mp3" }
        .map { $0.lastPathComponent }
        .sorted()
}

struct DetailView: View {
    @Bindable var item: Item
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var audioPlayer: AVAudioPlayer?
    private let mp3Files = getMP3Files()
    @State private var showAlert = false
    @State private var titleAlert = "Hey!"
    @State private var messageAlert = "This is reusable"

    var body: some View {
        formView
            .simpleAlert(isPresented: $showAlert, title: titleAlert, message: messageAlert)
            .navigationTitle("Add Alarm")
            HStack (spacing: 1) {
                Spacer()
                Button(role: .destructive) {
                    deleteItem()
                } label: {
                    Text("Delete")
                }
                Spacer()
            }
    }
    
    var formView: some View {
        Form {
            TextField("Item Name", text: $item.name)
                .font(.headline)
            DatePicker("Timestamp", selection: $item.timestamp)
                .font(.caption)

            HStack(spacing: 10) {
                Picker(selection: $item.sound) {
                    ForEach(mp3Files, id: \.self) { file in
                        Text(file)
                            .lineLimit(1)
                            .font(.callout)
                            .tag(file)
                    }
                } label: {
                    HStack {
                        Text("Sound")
                            .font(.caption)
                    }
                }
                .onChange(of: item.sound) { oldValue, newValue in
                    playSound()
                }
            }

            Slider(value: $item.volume, in: 0...10, step: 1)
                .onChange(of: item.volume) { oldValue, newValue in
                    playSound()
                }
        }
    }
    let audioService = AudioPlayerService()

    private func stopSound() {
        audioPlayer?.stop()
    }

    private func playSound() {
        if let url = Bundle.main.url(forResource: item.sound, withExtension: nil) {
            audioService.playSound(from: url, volumeLevel: Int(item.volume))
        } else {
            titleAlert = "Error"
            messageAlert = "❌ Could not find the sound file."
            showAlert.toggle()
        }
    }


    private func deleteItem() {
        withAnimation {
            stopSound()
            modelContext.delete(item)
            dismiss()
        }
    }

}

#Preview {
    DetailView(item: Item())
}
