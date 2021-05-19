//
//  ListDataManager.swift
//  ShoppingCart
//
//  Created by hassan Baraka on 5/17/21.
//

import Foundation



class ListDataManager {
    var coreDataStore = CoreDataStore.sharedInstance
    var productsArray = [Product]()
    var cartItems = [CartItem]()
    
    init() {
        if let products = readProductsFromPlist() {
            productsArray = products
        }
        
        cartItems(fromStore: ({ items in
            //TODO: Weak Self
            self.cartItems = items
        }))
    }
    
    func cartItems(fromStore completion: (([CartItem]) -> Void)!) {
        coreDataStore.fetchEntriesWithPredicate({ entries in
            completion(entries)
        })
    }
    
    func newCartItem() -> CartItem {
        return coreDataStore.newCartItem()
    }
    
    func saveMOC() {
        coreDataStore.save()
    }
    
    func deleteCartItem(withProductId productId: Int16) {
        coreDataStore.deleteCartItem(withProductId: productId)
    }
    
    func deleteObject(cartItem: CartItem) {
        coreDataStore.deleteObject(cartItem: cartItem)
    }
    
    func deleteSimilarProduct(cartItem: CartItem) {
        coreDataStore.checkForSimilarCartItemAndDelete(cartItemToCheck: cartItem)
    }
    
    func readProductsFromPlist() -> [Product]? {
        if let fileUrl = Bundle.main.url(forResource: "Products", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
                if let array = (result["Products"] as? [Any])  {
                    let productsArray = products(from: array)
//                    print(productsArray.count)
                    return productsArray
                }
            }
        }
        return nil
    }
    
    func products(from array: [Any]) -> [Product] {
        var productsArray = [Product]()
        for value in array {
            if let dict = value as? [String : Any] {
                let newProduct = Product()
                newProduct.productId = dict["productId"] as? NSNumber
                newProduct.name = dict["name"] as? String
                newProduct.categoryId = dict["categoryId"] as? NSNumber
                newProduct.price = dict["price"] as? NSNumber
                newProduct.imageName = dict["imageName"] as? String
                productsArray.append(newProduct)
            }
        }
        return productsArray
    }
    
}
