//
//  TableView.swift
//  relos
//
//  Created by Javier Fuchs on 26/07/2025.
//

import SwiftUI

struct TableView: View {
    @State private var isEnabled = Array(repeating: true, count: Item.limit)
    @Bindable var item: Item
    var index: Int
    let alarmManager: AlarmManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))
                .font(.largeTitle)
            HStack {
                Text(item.name.isEmpty ? "Alarm" : item.name)
                    .font(.headline)
                Toggle(isOn: $isEnabled[index]) {}
                    .onChange(of: isEnabled[index]) { oldValue, newValue in
                        item.isEnabled = newValue
                        alarmManager.cancelAlarm(for: item)
                        if newValue {
                            alarmManager.scheduleAlarm(for: item)
                        }
                    }
                    .onAppear {
                        isEnabled[index] = item.isEnabled
                    }
            }
        }
    }
}

#Preview {
    TableView(item: Item(), index: 1, alarmManager: AlarmManager())
}
