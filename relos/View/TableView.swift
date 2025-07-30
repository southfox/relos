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
            HStack {
                Text(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))
                    .font(.largeTitle)
                    .foregroundStyle(item.isInGray ? .gray : .primary)
                if item.isInThePast {
                    Spacer()
                    Text("Past")
                        .font(.default)
                        .padding(.horizontal, 16)
                        .foregroundColor(Color.gray)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20)
                }
            }
            HStack {
                Text(item.name.isEmpty ? "Alarm" : item.name)
                    .font(.headline)
                    .foregroundStyle(item.isInGray ? .gray : .primary)
                Toggle(isOn: item.isInThePast ? .constant(false) : $isEnabled[index]) {}
                    .tint(item.isInGray ? .gray : .green)
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
            Color(.lightGray)
                .frame(height: 0.5)
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    VStack {
        TableView(item: Item(timestamp: Date().addingTimeInterval(-1*60)), index: 1, alarmManager: AlarmManager())
        TableView(item: Item(timestamp: Date().addingTimeInterval(60*60)), index: 1, alarmManager: AlarmManager())
        TableView(item: Item(timestamp: Date().addingTimeInterval(3*60*60), isEnabled: false), index: 1, alarmManager: AlarmManager())
   }
}
