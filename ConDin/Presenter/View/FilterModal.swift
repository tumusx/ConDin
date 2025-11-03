//
//  FilterModal.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 18/10/25.
//

import SwiftUI

struct FilterModal: View {
    @State private var selectedMonth: Int
    @State private var selectedYear: Int
    
    var onSelect: (String) -> Void
    
    private let months = [
        "Janeiro", "Fevereiro", "Março", "Abril",
        "Maio", "Junho", "Julho", "Agosto",
        "Setembro", "Outubro", "Novembro", "Dezembro"
    ]
    
    private let years: [Int] = Array(2000...Calendar.current.component(.year, from: Date()))
    
    /// Inicializador que aceita um valor como "12/2022"
    init(
        selectedMonthYear: String? = nil,
        onSelect: @escaping (String) -> Void = { _ in }
    ) {
        if let value = selectedMonthYear {
            let components = value.split(separator: "/")
            let month = Int(components.first ?? "") ?? Calendar.current.component(.month, from: Date())
            let year = Int(components.last ?? "") ?? Calendar.current.component(.year, from: Date())
            _selectedMonth = State(initialValue: month)
            _selectedYear = State(initialValue: year)
        } else {
            _selectedMonth = State(initialValue: Calendar.current.component(.month, from: Date()))
            _selectedYear = State(initialValue: Calendar.current.component(.year, from: Date()))
        }
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Selecione o mês e o ano para filtragem")
                .font(.headline)
            
            HStack {
                Picker("Mês", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text(months[month - 1]).tag(month)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("Ano", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Button("Confirmar") {
                let formatted = String(format: "%02d/%d", selectedMonth, selectedYear)
                onSelect(formatted)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}


#Preview {
    FilterModal()
}
