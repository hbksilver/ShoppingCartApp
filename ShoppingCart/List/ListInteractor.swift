//
//  ListInteractor.swift
//  ShoppingCart
//
//  Created by hassan Baraka on 5/17/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ListInteractor {
    
    let dataManager : ListDataManager
    var products: BehaviorRelay<[Product]> = BehaviorRelay(value: [])
    var cartItems: BehaviorRelay<[CartItem]> = BehaviorRelay(value: [])
    
    init(dataManager: ListDataManager) {
        self.dataManager = dataManager
    }
    
    func fetchCartItemsFromStore() -> Observable<[CartItem]> {
        var array = self.cartItems.value
        array.removeAll()
        self.cartItems.accept(array)
        print(dataManager.cartItems as Any)
        for item in dataManager.cartItems {
            array.append(item)
        }
        print(array as Any)
        self.cartItems.accept(array)
        return Observable.create { observer in
            observer.onNext(self.cartItems.value)
            return Disposables.create()
        }
    }
    
    func fetchProductsFromStore() {
        var array = self.products.value
        array.removeAll()
        self.products.accept(array)
        for prod in dataManager.productsArray {
            array.append(prod)
        }
        self.products.accept(array)
        
        
    }
    
    
    func cartItemProducts(cartItems: [CartItem]) -> [Product] {
        var filteredProducts = [Product]()
        for item in cartItems {
            let fetchedProducts = filterProducts(data: dataManager.productsArray, withProductId: item.productId)
            if fetchedProducts.count > 0 {
                filteredProducts.append(fetchedProducts[0])
            }
        }
        return filteredProducts
    }
    func sectionedData(data: [Product]) -> [SectionModel<NSNumber, Product>] {
       
        var sectioned = [SectionModel<NSNumber, Product>]()
       
        for index in Category.Electronics.rawValue...Category.Furniture.rawValue {
            
            let filteredProducts = filterProducts(data: data, withCategoryId: index)
            let sectionModel = SectionModel(model: NSNumber(value: index), items: filteredProducts)
            print(sectionModel.items as Any)
            sectioned.append(sectionModel)
        }
        
        return removeEmptySections(sectionArray: sectioned)
    }
    
    
    
    func removeEmptySections(sectionArray: [SectionModel<NSNumber, Product>]) -> [SectionModel<NSNumber, Product>]  {
        var filteredSections = [SectionModel<NSNumber, Product>]()
        for sectionModel in sectionArray {
            if sectionModel.items.count > 0 {
                filteredSections.append(sectionModel)
            }
        }
        return filteredSections
    }
    
    func deleteCartItem(withProductId productId: Int16) {
        dataManager.deleteCartItem(withProductId: productId)
    }
    
    func filterProducts(data: [Product], withCategoryId categoryId: Int) -> [Product] {
        let returnValue = data.filter({
            return $0.categoryId.intValue == categoryId
        })
        return returnValue
    }
    
    func filterProducts(data: [Product], withProductId productId: Int16) -> [Product] {
        let returnValue = data.filter({
            return $0.productId.int16Value == productId
        })
        return returnValue
    }
    
}
