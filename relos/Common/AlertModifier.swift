//
//  AlertModifier.swift
//  relos
//
//  Created by Javier Fuchs on 26/07/2025.
//

import Foundation
import SwiftUI

struct AlertModel {
    var title: TitleError
    var message: String
    
    init(title: TitleError = .error, _ message: String = "Error occurred") {
        self.title = title
        self.message = message
    }
}

enum TitleError: String {
    case error
    case warning
    case info
}

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool

    let model: AlertModel

    func body(content: Content) -> some View {
        content
            .alert(model.title.rawValue, isPresented: $isPresented) {
                Button("OK", role: .cancel) {
                    isPresented.toggle()
                }
            } message: {
                Text(model.message)
                    .font(.subheadline)
            }
    }
}

#Preview("Error") {
    Text("Example Error")
        .simpleAlert(isPresented: .constant(true), model: AlertModel("This is an error message."))
}

#Preview("Warning") {
    Text("Example Warning")
        .simpleAlert(isPresented: .constant(true), model: AlertModel(title: .warning, "This is a warning message."))
}

#Preview("Info") {
    Text("Example Info")
        .simpleAlert(isPresented: .constant(true), model: AlertModel(title: .info, "This is a Info message."))
}

extension View {
    func simpleAlert(isPresented: Binding<Bool>, model: AlertModel) -> some View {
        self.modifier(AlertModifier(isPresented: isPresented, model: model))
    }
}
