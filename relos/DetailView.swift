import SwiftUI
import SwiftData

struct DetailView: View {
    @Bindable var item: Item

    var body: some View {
        Form {
            TextField("Item Name", text: $item.name)
            DatePicker("Timestamp", selection: $item.timestamp)
        }
        .navigationTitle("Item Details")
    }
}

#Preview {
    let sampleItem = Item(timestamp: Date(), name: "Sample Item")
    DetailView(item: sampleItem)
}
