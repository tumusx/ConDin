//
//  AddExpenses.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 22/09/25.
//

import SwiftUI

struct AddExpenses: View {
    private let closeScreen: (Bool) -> Void
    private let expenses: (Statement) -> Void
    
    @State private var date: Date = Date()
    @State private var paymentMethod: String = "Cartão de Crédito"
    @State private var category: String = ""
    @State private var establishment: String = ""
    @State private var value: String = ""
    
    private let paymentMethods = [
        "Cartão de Crédito",
        "Pix",
        "Cartão de Débito",
        "Dinheiro"
    ]
    
    private func colorForPaymentMethod(_ method: String) -> Color {
        switch method {
        case "Cartão de Crédito": return .blue
        case "Pix": return .purple
        case "Cartão de Débito": return .orange
        case "Dinheiro": return .green
        default: return .gray
        }
    }
    
    init(
        expenses: @escaping (Statement) -> Void = { _ in },
        closeScreen: @escaping (Bool) -> Void = { _ in }
    ) {
        self.expenses = expenses
        self.closeScreen = closeScreen
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button {
                    closeScreen(true)
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding()
                }
            }
            
            Text("Adicionar Transação")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Valor")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                TextField("R$ 0.00", text: $value)
                    .padding(12)
                    .background(Color(white: 0.95))
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Estabelecimento")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                TextField("Restaurante Delicias", text: $establishment)
                    .padding(12)
                    .background(Color(white: 0.95))
                    .cornerRadius(10)
            }
            
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Data")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color(white: 0.95))
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Pagamento")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Picker("Pagamento", selection: $paymentMethod) {
                        ForEach(paymentMethods, id: \.self) { method in
                            Text(method).tag(method)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(white: 0.95))
                    .cornerRadius(10)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Categoria")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                TextField("Alimentação", text: $category)
                    .padding(12)
                    .background(Color(white: 0.95))
                    .cornerRadius(10)
            }
            
            Button(action: {
                guard !value.isEmpty, !establishment.isEmpty else { return }
                
                let formattedValue = "R$ -\(value.replacingOccurrences(of: ".", with: ","))"
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy 'às' HH:mm"
                let formattedDate = formatter.string(from: date)
                
                let newCard = Statement(
                    category: category,
                    description: paymentMethod,
                    title: establishment,
                    value: formattedValue,
                    date: formattedDate,
                )
                
                expenses(newCard)
                closeScreen(true)
            }) {
                Text("Salvar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
    }
}

#Preview {
    AddExpenses()
}
