//
//  Home.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 21/09/25.
//

import SwiftUI

struct Home: View {
    @StateObject private var homeViewModel: HomeViewModel
    @State private var showAddScreen: Bool = false
    
    init() {
        _homeViewModel = StateObject(wrappedValue: HomeViewModel())
    }
    
    init(preview: HomeViewModel) {
        _homeViewModel = .init(wrappedValue: preview)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(systemName: "xmark.bin")
                    .font(.title2)
                    .padding(.horizontal, 30)
                    .onTapGesture {
                        homeViewModel.clearData()
                    }
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.title2)
                    .padding(.horizontal, 30)
                    .onTapGesture {
                        homeViewModel.openFilterModal()
                    }
                Image(systemName: "plus")
                    .font(.title2)
                    .padding(.horizontal, 30)
                    .onTapGesture {
                        showAddScreen = true
                    }
            }
                Balance(balance: homeViewModel.state.balance)
                    .padding(.vertical, 20)
                
                ScrollView {
                    CustomCharts(
                        expenses: homeViewModel.state.expenses,
                        month: homeViewModel.state.month
                    )
                    TransactionView(statement: homeViewModel.state.statement)
                }
                .frame(maxHeight: .infinity, alignment: .topLeading)
                .sheet(isPresented: $showAddScreen) {
                    AddExpenses(
                        expenses: { newStatement in
                            Task {
                                try? await homeViewModel.saveContent(content: newStatement)
                            }
                        },
                        closeScreen: { value in
                            showAddScreen = !value
                        }
                    )
                }
                .sheet(isPresented: $homeViewModel.state.showFilterModal) {
                    FilterModal(
                        selectedMonthYear: homeViewModel.state.month,
                    ) { selectedValue in
                        homeViewModel.filterDate(value: selectedValue)
                    }
                    .presentationDetents([.fraction(0.35)])
                    .presentationDragIndicator(.visible)
                    .padding(.horizontal, 20)
                }
                .task {
                    try? await homeViewModel.fetchData()
                }
            }
    }
}

#Preview {
    Home(preview: HomeViewModel.preview)
}
