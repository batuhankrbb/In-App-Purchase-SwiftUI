//
//  Store.swift
//  InAppTesting
//
//  Created by Batuhan Karababa on 21.01.2021.
//

import StoreKit



class StoreService:NSObject,ObservableObject{
    private let allProductIdentifiers = Set(["com.ibrahimkarababa.InAppTesting.removeAds"])
    
    private var fetchedProducts = [SKProduct]()
    private var fetchCompletionHandler: (([SKProduct]) -> Void)?
}

extension StoreService:SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else{
            print("Couldn't load the products.")
            if !invalidProducts.isEmpty{
                print("Invalid products found")
            }
            return
        }
        
        fetchedProducts = loadedProducts
        
        DispatchQueue.main.async {
            
        }
        
    }
}



