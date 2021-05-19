//
//  TotalCell.swift
//  ShoppingCart
//
//  Created by hassan Baraka on 5/17/21.
import Foundation
import UIKit

class TotalCell: UITableViewCell {
    
    static let Identifier = "TotalCell"
    
    //@IBOutlet private var totalPriceLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    func configure(withPrice price: Int) {
        totalPriceLabel.text = "$ \(price)"
    }
    
}
