//
//  ListViewController.swift
//  ShoppingCart
//
//  Created by hassan Baraka on 5/17/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

var ListCellIdentifier = "ListCell"

class ListViewController : UIViewController, UITableViewDelegate, Cart {
    
    var totalPrice: Int = 0
    var eventHandler : ListPresenter?
    var cartItems = [CartItem]()
    var screenType = ScreenType.List

    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<NSNumber, Product>>!

    var dataArray: BehaviorRelay<[SectionModel<NSNumber, Product>]> = BehaviorRelay(value: [])
    var dataVariableArray: BehaviorRelay<[SectionModel<NSNumber, Product>]> = BehaviorRelay(value: [])
     
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var tableView : UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(screenType)
        eventHandler?.updateView(screenType: screenType)
        
    }
    
    
    func configureView() {
        //Title
        navigationItem.title = "Products"
        var dataSource = self.dataSource
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<NSNumber, Product>>(
          configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
            cell.screenType = self.screenType
            cell.configureWithProduct(product: item)
            return cell
        })
        
        dataSource!.canEditRowAtIndexPath = { dataSource, indexPath in
            true//self.canEditCell()
        }
        
    
        dataSource!.titleForHeaderInSection = { dataSource, sectionIndex in
            return Category(rawValue: dataSource[sectionIndex].model.intValue)?.title()
        }
        
        dataArray
            .asObservable()
            .bind(to:tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource![indexPath])
            }
            .subscribe(onNext: { indexPath, model in
                self.eventHandler?.showDetail(product: model)
            })
            .disposed(by:disposeBag)
            

        tableView.rx
            .itemDeleted
            .map { indexPath in
                return (indexPath, dataSource![indexPath])
            }
            .subscribe(onNext: { indexPath, model in
                self.deleteCartItem(withProduct: model)
            })
            .disposed(by:disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by:disposeBag)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func deleteCartItem(withProduct product: Product) {
        eventHandler?.deleteCartItem(withProductId: product.productId.int16Value)
        updateCartCount()
        eventHandler?.updateView(screenType: screenType)

    }
    
    func canEditCell() -> Bool {
        if self.screenType == .Cart {
            return true
        }
        return false
    }
    
    func totalCellView() -> UIView {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell") as! TotalCell
        cell.configure(withPrice: self.totalPrice)
        return cell
    }
    /*
    //To prevent swipe to delete behavior
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if screenType == .Cart {
            return true
        }
        return false
    }
 

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if screenType == .Cart {
            return .delete
        }
        return .none
    }
 
     */
    
   
    
    //MARK:
    //MARK: Cart Protocol Methods
    func cartIconTapped() {
        //Tapped
        navigate(toCart: self)
    }
    
    //MARK:
    //MARK: Utility Methods
    func calculateTotalPrice(sectioned data: [SectionModel<NSNumber, Product>]) -> Int {
        var total = 0
        for section in data {
            for product in section.items {
                total += product.price.intValue
            }
        }
        return total
    }
    
    //MARK:
    //MARK: Other Methods
    
    
    func updatedCartItems(_ cartItems: [CartItem]) {
        self.cartItems = cartItems
        updateCartCount()
    }
    
    //MARK:
    //MARK: Other Methods
    func showProducts(sectioned data: [SectionModel<NSNumber, Product>]) {
        if screenType == ScreenType.Cart {
            totalPrice = calculateTotalPrice(sectioned: data)
            tableView.tableFooterView = totalCellView()
        }
        dataArray.accept(data)
    }
    
}

