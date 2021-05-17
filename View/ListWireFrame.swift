//
//  ListWireFrame.swift
//  ShoppingCart
//
//  Created by hassan Baraka on 5/17/21.
import Foundation
import UIKit

let ListViewControllerIdentifier = "ListViewController"

class ListWireframe : NSObject {
    var listPresenter : ListPresenter?
    var rootWireframe : RootWireframe?
    var listViewController : ListViewController?
    
    func configuredListViewController() -> ListViewController {
        let viewController = listViewControllerFromStoryboard()
        viewController.eventHandler = listPresenter
        listViewController = viewController
        listPresenter?.userInterface = viewController
        return viewController
    }
    
    func navigate(toCart fromViewController: UIViewController) {
        let cartViewController = configuredListViewController()
        cartViewController.screenType = .Cart
        fromViewController.navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    func navigateToDetail(withProduct product: Product) {
        let detailWireframe = DetailWireframe()
        let detailManager = DetailManager()
        let detailInteractor = DetailInteractor(detailManager: detailManager)
        let detailPresenter = DetailPresenter()
        detailPresenter.detailInteractor = detailInteractor
        detailPresenter.detailWireframe = detailWireframe
        detailWireframe.detailPresenter = detailPresenter
        detailWireframe.presentDetailInterface(fromViewController: listViewController!, withProduct: product)
    }
    
    func presentListInterfaceFromWindow(_ window: UIWindow) {
        let viewController = configuredListViewController()
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func listViewControllerFromStoryboard() -> ListViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: ListViewControllerIdentifier) as! ListViewController
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
    
}
