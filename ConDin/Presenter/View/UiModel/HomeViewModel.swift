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
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .decimal
        let clean = self.replacingOccurrences(of: "R$ ", with: "")
        return formatter.number(from: clean)?.doubleValue ?? 0
    }
}

class HomeViewModel: ObservableObject {
    
    private var applicationRepository: ApplicationRepository = ApplicationRepository()
    
    @Published var state: HomeViewState = HomeViewState(isloading: true)
    
    internal func onBalanceChange(value: String) {
        self.state.actualBalance = value
        applicationRepository.saveActualBalance(value: value)
    }
    
    // MARK: - Public Methods
    
    func openFilterModal() {
        self.state.showFilterModal = true
    }
    
    private func fetchAllContent(month: String = "", isOpenFilterModal: Bool = false) async throws -> HomeViewState{
        let data = try applicationRepository.loadContent(monthYear: month) ?? []
        let expenses = calculateExpenses(from: data)
        let resumeBalance = calculateActualBalance(from: data, actualBalance: applicationRepository.loadActualBalance())
        let coust = calculateCoust(from: data)
        return HomeViewState(
            statement: data,
            month: month,
            expenses: expenses,
            actualBalance: resumeBalance,
            balance: coust,
            isloading: false,
            isError: false,
            isEmpty: data.isEmpty
        )
    }
    
    @MainActor
    func initData() async {
        do {
            let state = try await fetchAllContent(month: currentMonth())
            self.state = state
        } catch {
            print("Erro ao carregar dados: \(error)")
            self.state.isError = true
        }
    }

    func filterDate(value: String) {
        self.state.showFilterModal = false
        self.state.month = value
        Task {
            let value = try await fetchAllContent(month: value)
            DispatchSerialQueue.main.sync {
                self.state = value
            }
        }
    }
    
    func clearData() {
        applicationRepository.clearData()
        self.state = HomeViewState(
            statement: [],
            month: currentMonth(),
            expenses: [],
            actualBalance: "",
            balance: "R$ 0.00",
            isloading: false,
            isError: false,
            isEmpty: true
        )
    }
    
    func saveContent(content: Statement) async throws {
        let content = try applicationRepository.saveContent(content: content) ?? []
        let expenses = calculateExpenses(from: content)
        let resumeBalance = calculateActualBalance(from: content, actualBalance: applicationRepository.loadActualBalance())
        let coust = calculateCoust(from: content)
        DispatchSerialQueue.main.sync {
            self.state = HomeViewState(
                statement: content,
                month: currentMonth(),
                expenses: expenses,
                actualBalance: resumeBalance,
                balance: coust,
                isloading: false,
                isError: false
            )
        }
    }
    
    // MARK: - Private Helpers
    private func calculateExpenses(from statements: [Statement]) -> [Expense] {
        var grouped: [String: Double] = [:]
        
        for s in statements {
            let value = s.value.currencyToDouble()
            grouped[s.category, default: 0] += value
        }
        
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
    
    private func calculateCoust(from statements: [Statement]) -> String {
        let total = statements.map { $0.value.currencyToDouble() }.reduce(0, +)
        return "R$ \(String(format: "%.2f", total))"
    }
    
    private func calculateActualBalance(from statements: [Statement], actualBalance: String) -> String {
        let initialBalance = actualBalance.currencyToDouble()
        
        let totalStatements = statements.map { $0.value.currencyToDouble() }.reduce(0, +)
        
        let finalBalance = initialBalance + totalStatements
        
        return "R$ \(String(format: "%.2f", finalBalance))"
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
            actualBalance: fakeViewModel.calculateActualBalance(from: fakeStatements, actualBalance: "10"),
            balance: fakeViewModel.calculateCoust(from: fakeStatements),
            isloading: false,
            isError: false
        )
        
        return fakeViewModel
    }
}
