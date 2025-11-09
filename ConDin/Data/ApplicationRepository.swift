//
//  ApplicationRepository.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 27/09/25.
//

import SwiftData
import Foundation

class ApplicationRepository {
    private let key = "statement_key"
    private let balance_key = "balance_key"
    
    private func filterByMonthYear(monthYear: String, list: [Statement]) -> [Statement] {
        
        if monthYear.isEmpty {
            return list
        } else {
            return list
                .filter { $0.date.contains(monthYear) }
                .sorted { $0.date > $1.date }
        }
    }
    
    func saveActualBalance(value: String) {
        UserDefaults.standard.set(value, forKey: balance_key)
    }
    
    func loadActualBalance() -> String {
        let value = UserDefaults.standard.string(forKey: balance_key) ?? ""
        return value
    }
    
    func saveContent(content: Statement) throws -> [Statement]? {
        var currentList = try loadContent(monthYear: currentMonth()) ?? []
        currentList.append(content)
        let data = try JSONEncoder().encode(currentList)
        UserDefaults.standard.set(data, forKey: key)
        return filterByMonthYear(monthYear: currentMonth(), list: currentList)
    }
    
    func clearData() {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
    }
    
    func loadContent(monthYear: String = "") throws -> [Statement]? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let statement = try JSONDecoder().decode([Statement].self, from: data)
        return filterByMonthYear(monthYear: monthYear, list: statement)
    }
}
