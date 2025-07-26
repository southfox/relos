//
//  AlertModifier.swift
//  relos
//
//  Created by Javier Fuchs on 26/07/2025.
//

import Foundation
import SwiftUI

struct AlertModel {
    let title: String
    let message: String
}

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool

    let model: AlertModel

    func body(content: Content) -> some View {
        content
            .alert(model.title, isPresented: $isPresented) {
                Button("OK", role: .cancel) {
                    isPresented.toggle()
                }
            } message: {
                Text(model.message)
                    .font(.subheadline)
            }
    }
}

extension View {
    func simpleAlert(isPresented: Binding<Bool>, model: AlertModel) -> some View {
        self.modifier(AlertModifier(isPresented: isPresented, model: model))
    }
}
