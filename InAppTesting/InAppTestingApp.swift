//
//  InAppTestingApp.swift
//  InAppTesting
//
//  Created by Batuhan Karababa on 21.01.2021.
//

import SwiftUI

@main
struct InAppTestingApp: App {
  
    @StateObject var store = StoreService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                
        }
    }
}

