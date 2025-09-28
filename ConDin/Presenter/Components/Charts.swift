//
//  Charts.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 21/09/25.
//

import SwiftUI
import Charts

struct CustomCharts : View {
    var expenses: [Expense]
    var month: String

    var body: some View {
        VStack {
            Text("Este mês de " + month )
                .font(.headline)
                .foregroundColor(.gray)
            Chart(expenses) { expense in
                SectorMark(
                    angle: .value("Valor", expense.value),
                    innerRadius: .ratio(0.6),
                    outerRadius: .inset(10)
                )
                .foregroundStyle(expense.color)
            }
            .frame(height: 250)
            
            HStack(spacing: 20) {
                ForEach(expenses) { expense in
                    Label {
                        Text(expense.category)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .foregroundColor(.gray)
                    } icon: {
                        Circle()
                            .fill(expense.color)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

#Preview {
    let expenses: [Expense] = [
        Expense(category: "Alimentação", value: 300, color: .blue),
        Expense(category: "Transporte", value: 200, color: .teal),
        Expense(category: "Lazer", value: 150, color: .orange),
        Expense(category: "Outros", value: 100, color: .purple)
    ]
    
    CustomCharts(expenses: expenses, month: "Dezembro")
}
