//
//  Recipe.swift
//  InAppTesting
//
//  Created by Batuhan Karababa on 21.01.2021.
//

import StoreKit

//Note for myself = We need to create a class to store details of in app purchase item like formatted prices for ads.
struct Recipe:Hashable{
    let id:String
    let title:String
    let description:String
    var isLocked:Bool
    var price:String?
    let locale:Locale
    let imageName:String
    
    lazy var formatter:NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        return numberFormatter
    }()
    
    init(product:SKProduct, isLocked:Bool = true) {
        self.id = product.productIdentifier
        self.title = product.localizedTitle
        self.description = product.localizedDescription
        self.isLocked = isLocked
        self.locale = product.priceLocale
        self.imageName = product.productIdentifier
        if isLocked{
            self.price = formatter.string(from: product.price)
        }
    }
    
}
