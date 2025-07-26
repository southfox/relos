//
//  AlertModifier.swift
//  relos
//
//  Created by Javier Fuchs on 26/07/2025.
//

import Foundation
import SwiftUI

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool

    let title: String
    let message: String

    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                Button("OK", role: .cancel) {
                    isPresented.toggle()
                }
            } message: {
                Text(message)
            }
    }
}

extension View {
    func simpleAlert(isPresented: Binding<Bool>, title: String, message: String) -> some View {
        self.modifier(AlertModifier(isPresented: isPresented, title: title, message: message))
    }
}
