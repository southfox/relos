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
    @State private var showAlert = false
    @State private var alertModel = AlertModel(title: "", message: "")

    var body: some View {
        NavigationSplitView {
            listView
                .simpleAlert(isPresented: $showAlert, model: alertModel)

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
    
    private var listView: some View {
        List {
            ForEach(Array(items.sorted(by: { $0.timestamp < $1.timestamp }).enumerated()), id: \.element.id) { index, item in
                NavigationLink {
                    DetailView(item: item)
                } label: {
                    TableView(item: item, index: index)
                }
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    private func addItem() {
        withAnimation {
            guard items.count < 50 else {
                alertModel = AlertModel(title: "Error", message: "❌ Could not add more than 10 items.")
                showAlert.toggle()
                return
            }
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
