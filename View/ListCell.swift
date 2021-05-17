//
//  ListViewCell.swift
//  ShoppingCart
//
//  Created by hassan Baraka on 5/17/21.
//

import Foundation
import UIKit

class ListCell: UITableViewCell {
    
    static let Identifier = "ListCell"
    
    @IBOutlet internal var productImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
   
    var screenType = ScreenType.List
    
    func configureWithProduct(product: Product) {
        guard let productName = product.name, let productPrice = product.price else {
            return
        }
        
        nameLabel.text = productName
        productImageView.image = UIImage(named: product.imageName)
        priceLabel.text = productPrice.stringValue
    }
    
}
