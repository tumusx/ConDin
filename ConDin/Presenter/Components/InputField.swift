//
//  InputField.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 20/09/25.
//
import SwiftUI

struct InputField: View {
    @Binding var value: String
    var label: String
    
    var textColor: Color = .green
    var placeholderColor: Color = .gray
    var borderColor: Color = .green
    var backgroundColor: Color = .white
    var shadowColor: Color = .green.opacity(0.2)
    
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("", text: $value, prompt: Text(label).foregroundColor(placeholderColor))
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? borderColor : borderColor.opacity(0.7), lineWidth: 2)
                    )
            )
            .shadow(color: shadowColor, radius: 5, x: 0, y: 2)
            .foregroundColor(textColor)
            .font(.headline)
            .padding(.horizontal)
            .animation(.easeInOut, value: value)
    }
}

#Preview {
    VStack(spacing: 20) {
        InputField(
            value: .constant(""),
            label: "Digite o valor",
            textColor: .red,
            placeholderColor: .red,
            borderColor: .blue,
            backgroundColor: Color(white: 0.95),
            shadowColor: .blue.opacity(0.2)
        )
        
        InputField(
            value: .constant(""),
            label: "Valor inicial",
            textColor: .red,
            placeholderColor: .pink,
            borderColor: .red,
            backgroundColor: .white,
            shadowColor: .red.opacity(0.2)
        )
    }
    .padding()
}
