//
//  Constants.swift
//  
//
//  Created by hassan Baraka on 5/14/21.
//

import Foundation

enum Category : Int {
    case Electronics = 1, Furniture = 2
    
    func title() -> String {
        switch self {
        case.Electronics:
            return "Electronics"
        default:
            return "Furniture"
        }
    }
}

enum ScreenType {
    case List, Cart
    
    func title() -> String {
        switch self {
        case .List:
            return "Products"
        default:
            return "Cart"
        }
    }
    
}
