//
//  ContentView.swift
//  InAppTesting
//
//  Created by Batuhan Karababa on 21.01.2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var store:StoreService
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
