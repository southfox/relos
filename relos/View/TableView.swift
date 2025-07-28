//
//  TableView.swift
//  relos
//
//  Created by Javier Fuchs on 26/07/2025.
//

import SwiftUI

struct TableView: View {
    // TBD: 50 is hardcoded, make a constant with that
    @State private var isEnabled = Array(repeating: true, count: 50)
    @Bindable var item: Item
    var index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.name.isEmpty ? "Alarm" : item.name)
                .font(.headline)
            Text(item.timestamp, format: Date.FormatStyle(date: .complete, time: .shortened))
                .font(.subheadline)
            Toggle(isOn: $isEnabled[index]) {}
                .onChange(of: isEnabled[index]) { oldValue, newValue in
                    item.isEnabled = newValue
                }
                .onAppear {
                    isEnabled[index] = item.isEnabled
                }
        }
    }
}

#Preview {
    TableView(item: Item(), index: 1)
}
