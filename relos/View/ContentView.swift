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
    @State private var alertModel = AlertModel()
    @State private var selectedItem: Item? = nil
    private let alarmManager = AlarmManager()


    var body: some View {
        content
            .onAppear {
                alarmManager.scheduleAlarms(for: items)
            }
    }
    var content: some View {
#if os(watchOS)
        NavigationStack() {
            listView
                .simpleAlert(isPresented: $showAlert, model: alertModel)
                .navigationTitle("Alarms")
                .navigationBarTitleDisplayMode(.inline)
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
#else
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
            if let selectedItem = selectedItem {
                DetailView(item: selectedItem, alarmManager: alarmManager)
            }
        }
#endif
    }
    
    private var listView2: some View {
        List(selection: $selectedItem) {
            ForEach(Array(items.sorted(by: { $0.timestamp < $1.timestamp }).enumerated()), id: \.element.id) { index, item in
                NavigationLink {
                    DetailView(item: selectedItem ?? item, alarmManager: alarmManager)
                } label: {
                    TableView(item: item, index: index, alarmManager: alarmManager)
                }
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    private var listView: some View {
        List(selection: $selectedItem) {
            ForEach(items.sortedKeys, id: \.self) { day in
                Section {
                    ForEach(Array((items.groupedItems[day] ?? []).sorted(by: { $0.timestamp < $1.timestamp }).enumerated()), id: \.element.id) { index, item in
                        NavigationLink {
                            DetailView(item: selectedItem ?? item, alarmManager: alarmManager)
                        } label: {
                            TableView(item: item, index: index, alarmManager: alarmManager)
                        }
                    }
                } header: {
                    Text(day, format: .dateTime.weekday().day().month().year())
                        .font(.title2)
                } footer: {
                }
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    private func addItem() {
        withAnimation {
            guard items.count < Item.limit else {
                alertModel = AlertModel("Could not add more than \(Item.limit) items.")
                showAlert.toggle()
                return
            }
            let newItem = items.createUniqueItem(with: "Alarm")
            modelContext.insert(newItem)
            selectedItem = newItem
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
