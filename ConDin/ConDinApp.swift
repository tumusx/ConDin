//
//  ConDinApp.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 20/09/25.
//

import SwiftUI
import FirebaseCore

@main
struct ConDinApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
