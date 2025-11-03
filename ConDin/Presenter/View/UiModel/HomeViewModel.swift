//
//  HomeViewModel.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 21/09/25.
//

import SwiftUI

extension String {
    /// Converte "R$ -120,00" para -120.0
    func currencyToDouble() -> Double {
        let clean = self
            .replacingOccurrences(of: "R$", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(clean) ?? 0.0
    }
}

class HomeViewModel: ObservableObject {
    
    private var applicationRepository: ApplicationRepository = ApplicationRepository()
    
    private func currentMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/YYYY"
        return dateFormatter.string(from: Date())
    }
    
    @Published var state: HomeViewState = HomeViewState(isloading: true)
    
    // MARK: - Public Methods
    
    func fetchData() async throws {
        let data = try applicationRepository.loadContent() ?? []
        let expenses = calculateExpenses(from: data)
        let balance = calculateBalance(from: data)
        let month = currentMonth()
        DispatchQueue.main.async {
            self.state = HomeViewState(
                statement: data,
                month: month,
                expenses: expenses,
                balance: balance,
                isloading: false,
                isError: false,
                isEmpty: data.isEmpty
            )
        }
    }
    
    func openFilterModal() {
        self.state.showFilterModal = true
    }
    
    func filterDate(value: String) {
        self.state.showFilterModal = false
        self.state.month = value
    }
    
    func clearData() {
        applicationRepository.clearData()
        self.state = HomeViewState(
            statement: [],
            month: currentMonth(),
            expenses: [],
            balance: "R$ 0.00",
            isloading: false,
            isError: false,
            isEmpty: true
        )
    }
    
    func saveContent(content: Statement) async throws {
        let content = try applicationRepository.saveContent(content: content) ?? []
        let expenses = calculateExpenses(from: content)
        let balance = calculateBalance(from: content)
        self.state = HomeViewState(
            statement: content,
            month: currentMonth(),
            expenses: expenses,
            balance: balance,
            isloading: false,
            isError: false
        )
    }
    
    // MARK: - Private Helpers
    private func calculateExpenses(from statements: [Statement]) -> [Expense] {
        var grouped: [String: Double] = [:]
        
        for s in statements {
            let value = s.value.currencyToDouble()
            grouped[s.category, default: 0] += value
        }
        
        // Defina cores fixas por categoria
        let categoryColors: [String: Color] = [
            "Alimentação": .blue,
            "Transporte": .teal,
            "Lazer": .orange,
            "Outros": .purple,
            "Cartão de Crédito": .green,
            "Cartão de Débito": .red,
            "Pix": .pink,
            "Boleto": .gray,
            "Dinheiro": .yellow
        ]
        
        return grouped.map { category, total in
            Expense(
                category: category,
                value: total,
                color: categoryColors[category] ?? .gray
            )
        }
    }
    
    private func calculateBalance(from statements: [Statement]) -> String {
        let total = statements.map { $0.value.currencyToDouble() }.reduce(0, +)
        return "R$ \(String(format: "%.2f", total))"
    }
}

// MARK: - Preview
extension HomeViewModel {
    static var preview: HomeViewModel {
        let fakeViewModel = HomeViewModel()
        
        let fakeStatements: [Statement] = [
            Statement(category: "Cartão de Crédito", description: "Cartão de Crédito", title: "Restaurante Delicias", value: "R$ -120,00", date: "21/09/2025 às 12:30"),
            Statement(category: "Cartão de Débito", description: "Cartão de Débito", title: "Supermercado Bom Preço", value: "R$ -250,00", date: "20/09/2025 às 15:00"),
            Statement(category: "Cartão de Crédito", description: "Cartão de Crédito", title: "Academia Fitness", value: "R$ -180,00", date: "19/09/2025 às 08:30"),
            Statement(category: "Pix", description: "Pix", title: "Pagamento Cliente X", value: "R$ 500,00", date: "18/09/2025 às 10:45"),
            Statement(category: "Boleto", description: "Boleto", title: "Mensalidade Escola", value: "R$ -300,00", date: "15/09/2025 às 09:00"),
            Statement(category: "Dinheiro", description: "Dinheiro", title: "Café e Lanches", value: "R$ -50,00", date: "14/09/2025 às 11:30")
        ]
        
        fakeViewModel.state = HomeViewState(
            statement: fakeStatements,
            month: "Setembro",
            expenses: fakeViewModel.calculateExpenses(from: fakeStatements),
            balance: fakeViewModel.calculateBalance(from: fakeStatements),
            isloading: false,
            isError: false
        )
        
        return fakeViewModel
    }
}
