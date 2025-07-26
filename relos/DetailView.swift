import SwiftUI
import SwiftData

struct DetailView: View {
    @Bindable var item: Item

    var body: some View {
        Form {
            TextField("Item Name", text: $item.name)
            Text("Timestamp: \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
        }
        .navigationTitle("Item Details")
    }
}
