//
//  Expense.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 21/09/25.
//
import SwiftUI

struct Expense: Identifiable {
    var id = UUID()
    var category: String
    var value: Double
    var color: Color
}
