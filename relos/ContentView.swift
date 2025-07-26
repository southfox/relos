//
//  ContentView.swift
//  relos
//
//  Created by Javier Fuchs on 26/07/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var isEnabled: Bool = true

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items.sorted(by: { $0.timestamp < $1.timestamp})) { item in
                    NavigationLink {
                        DetailView(item: item)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name.isEmpty ? "Alarm" : item.name)
                                .font(.headline)
                            Text(item.timestamp, format: Date.FormatStyle(date: .complete, time: .shortened))
                                .font(.subheadline)
                            Toggle(isOn: $isEnabled) {}
                                .onChange(of: isEnabled) { oldValue, newValue in
                                    item.isEnabled = newValue
                                }
                                .onAppear {
                                    isEnabled = item.isEnabled
                                }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item()
            newItem.name = "Alarm #\(items.count + 1)"
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
