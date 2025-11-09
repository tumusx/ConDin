//
//  Util.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 09/11/25.
//
import Foundation


internal func currentMonth() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/YYYY"
    return dateFormatter.string(from: Date())
}
