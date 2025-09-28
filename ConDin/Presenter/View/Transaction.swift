//
//  TransactionVoe.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 21/09/25.
//
import SwiftUI

struct TransactionView: View {
    var statement: [Statement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Transações recentes")
                .font(.headline)
                .fontWeight(.bold)
                .padding()
                ForEach(statement.indices, id: \.self) { index in
                    let statement = statement[index]
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(statement.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(statement.date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            Text(statement.description)
                                .font(.callout)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(statement.value)
                                .font(.callout)
                                .foregroundColor(.red)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                    )
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
            }
        }
    }
}

#Preview {
    TransactionView(
        statement: [
            Statement(description: "Cartão de Crédito", title: "Restaurante Delicias", value: "R$ -120,00", date: "21/09/2025 às 12:30"),
            Statement(description: "Cartão de Débito", title: "Supermercado Bom Preço", value: "R$ -250,00", date: "20/09/2025 às 15:00"),
            Statement(description: "Pix", title: "Pagamento Cliente X", value: "R$ 500,00", date: "18/09/2025 às 10:45")
        ]
    )
}

