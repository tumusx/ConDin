//
//  HomeViewState.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 27/09/25.
//

struct HomeViewState {
    var statement: [Statement] = []
    var month: String = ""
    var showFilterModal: Bool = false
    var expenses: [Expense] = []
    var balance: String = ""
    var isloading: Bool = false
    var isError: Bool = false
    var isEmpty: Bool = false
}
