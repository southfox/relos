import SwiftUI
import SwiftData
import AVFoundation

struct DetailView: View {
    @Bindable var item: Item
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showAlert = false
    @State private var alertModel = AlertModel(title: "", message: "")
    private let audioService = AudioPlayerService()

    var body: some View {
        formView
            .simpleAlert(isPresented: $showAlert, model: alertModel)
            .navigationTitle("Add Alarm")
            .onDisappear {
                stopSound()
            }
        toolbar
    }
    
    private var formView: some View {
        Form {
            HStack {
                itemName
                enabledToogle
            }
            datePicker
            mp3List
            slider
            enabledSnooze
        }
    }
    
    private var toolbar: some View {
        HStack(spacing: 1) {
            Spacer()
            Button(role: .destructive) {
                deleteItem()
            } label: {
                Text("Delete")
                    .font(.headline)
            }
            Spacer()
        }
    }
    
    private var itemName: some View {
        TextField("Alarm", text: $item.name)
            .font(.body)
    }
    
    private var enabledToogle: some View {
        Toggle(isOn: $item.isEnabled) {}
    }
    
    private var datePicker: some View {
        DatePicker("Timestamp", selection: $item.timestamp)
            .font(.body)
    }
    
    private var mp3List: some View {
        HStack(spacing: 10) {
            Picker(selection: $item.sound) {
                ForEach(audioService.mp3Files, id: \.self) { file in
                    Text(file)
                        .lineLimit(1)
                        .font(.callout)
                        .tag(file)
                }
            } label: {
                HStack {
                    Text("Sound")
                        .font(.body)
                }
            }
            .onChange(of: item.sound) { oldValue, newValue in
                playSound()
            }
        }
    }
    
    private var slider: some View {
        Slider(value: $item.volume, in: 0...10, step: 1)
            .onChange(of: item.volume) { oldValue, newValue in
                playSound()
            }
    }
    
    private var enabledSnooze: some View {
        Toggle(isOn: $item.isSnooze) {
            Text("Snooze")
                .font(.body)
        }
    }
    
    private func stopSound() {
        audioPlayer?.stop()
    }

    private func playSound() {
        if let url = Bundle.main.url(forResource: item.sound, withExtension: nil) {
            do {
                try audioService.playSound(from: url, volumeLevel: Int(item.volume))
            } catch {
                alertModel = AlertModel(title: "Error", message: "❌ Failed to play audio: \(error.localizedDescription)")
                showAlert.toggle()
            }
        } else {
            alertModel = AlertModel(title: "Error", message: "❌ Could not find the sound file.")
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
