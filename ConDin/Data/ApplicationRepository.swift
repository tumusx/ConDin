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
    
    func saveContent(content: Statement) throws -> [Statement]? {
        var currentList = try loadContent() ?? []
        currentList.append(content)
        let data = try JSONEncoder().encode(currentList)
        UserDefaults.standard.set(data, forKey: key)
        return currentList
    }
    
    func clearData() {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
    }
    
    func loadContent() throws -> [Statement]? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try JSONDecoder().decode([Statement].self, from: data)
    }
}
