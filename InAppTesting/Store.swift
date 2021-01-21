//
//  Store.swift
//  InAppTesting
//
//  Created by Batuhan Karababa on 21.01.2021.
//

import StoreKit

typealias FetchCompletionHandler = (([SKProduct]) -> Void)

class StoreService:NSObject,ObservableObject{
    private let allProductIdentifiers = Set(["com.ibrahimkarababa.InAppTesting.removeAds"])
    
    private var productsRequest:SKProductsRequest?
    private var fetchedProducts = [SKProduct]()
    private var fetchCompletionHandler:FetchCompletionHandler?
    
    override init() {
        super.init()
        fetchProducts { (products) in
            print(products)
        }
    }
    
    private func fetchProducts(_ completion: @escaping FetchCompletionHandler){
        guard self.productsRequest == nil else {
            return
        }
        
        fetchCompletionHandler = completion
        
        self.productsRequest = SKProductsRequest(productIdentifiers: allProductIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
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
            self.productsRequest = nil
            return
        }
        
        fetchedProducts = loadedProducts
        
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedProducts)
            self.fetchCompletionHandler = nil
            self.productsRequest = nil
        }
        
    }
}



