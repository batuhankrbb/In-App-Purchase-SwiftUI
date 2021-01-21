//
//  Store.swift
//  InAppTesting
//
//  Created by Batuhan Karababa on 21.01.2021.
//

import StoreKit

typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)

class StoreService:NSObject,ObservableObject{
    
    @Published var unlockedRecipes = [Recipe]()
    
    private let allProductIdentifiers = Set(["com.ibrahimkarababa.InAppTesting.removeAds"])
    
    private var productsRequest:SKProductsRequest?
    private var fetchedProducts = [SKProduct]()
    private var fetchCompletionHandler:FetchCompletionHandler? // Assigned in fetchProducts, executed in ProductRequestDidReceive
    private var purchaseCompletionHandler:PurchaseCompletionHandler? // Assigned in buy, executed in PaymentQueueUpdatedTransaction
    
    private var completedPurchases = [String]()
    
    override init() {
        super.init()
        startObservingPaymentQueue()
        
        fetchProducts { (products) in
            print(products)
        }
    }
    
    private func startObservingPaymentQueue(){
        SKPaymentQueue.default().add(self)
    }
    
    private func fetchProducts(_ completion: @escaping FetchCompletionHandler){ // Send fetch request to App Store to get products
        guard self.productsRequest == nil else {
            return
        }
        
        fetchCompletionHandler = completion
        
        self.productsRequest = SKProductsRequest(productIdentifiers: allProductIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    private func buy(_ product: SKProduct, completion: @escaping PurchaseCompletionHandler){
        purchaseCompletionHandler = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension StoreService{
    func purchaseProduct(_ product: SKProduct){
        buy(product){_ in }
    }
}

extension StoreService:SKPaymentTransactionObserver{ //Observes payment state
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for singleTransaction in transactions{
            var shouldFinishTransaction = false
            switch singleTransaction.transactionState {
            
            case .purchased,.restored:
                completedPurchases.append(singleTransaction.payment.productIdentifier)
                shouldFinishTransaction = true
            case .failed:
                shouldFinishTransaction = true
            case .purchasing,.deferred:
                break
            @unknown default:
                break
            }
            
            if shouldFinishTransaction{ // If user completed either purchasing or canceling
                SKPaymentQueue.default().finishTransaction(singleTransaction)
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(singleTransaction)
                    self.purchaseCompletionHandler = nil
                }
            }
            
        }
    }
}

extension StoreService:SKProductsRequestDelegate{
    // It works when products receive. It assings products to fetched products and Trigger fetchCompletionHandler.
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



