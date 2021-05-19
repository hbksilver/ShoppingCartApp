//
//  DetailManagers.swift
//  ShoppingCart
//
//  Created by hassan Baraka on 5/17/21.
//

import Foundation
class DetailManager {
    var dataStore = CoreDataStore.sharedInstance
 
    func saveMOC() {
        dataStore.save()
    }
    
    func newCartItem() -> CartItem {
        return dataStore.newCartItem()
    }

    func deleteObject(cartItem: CartItem) {
        dataStore.deleteObject(cartItem: cartItem)
    }
    
    func cartItemsFromStore(_ completion: (([CartItem]) -> Void)!) {
        dataStore.fetchEntriesWithPredicate({ entries in
            completion(entries)
        })
    }
    
    func save(cartItem: CartItem) {
        deleteSimilarCartItems(cartItem: cartItem)
        saveMOC()
    }
    
    func deleteSimilarCartItems(cartItem: CartItem) {
        dataStore.checkForSimilarCartItemAndDelete(cartItemToCheck: cartItem)
    }

    func delete(cartItem: CartItem) {
        dataStore.deleteObject(cartItem: cartItem)
    }
    
}
