import Foundation
import CoreData
import RxSwift
import RxCocoa

class CoreDataStore : NSObject {
    static let sharedInstance = CoreDataStore()
    var persistentStoreCoordinator : NSPersistentStoreCoordinator!
    var managedObjectModel : NSManagedObjectModel!
    var managedObjectContext : NSManagedObjectContext!
    

    let cartItemsArray: BehaviorRelay<[CartItem]> = BehaviorRelay(value: [])
    
    override init() {
        managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let domains = FileManager.SearchPathDomainMask.userDomainMask
        let directory = FileManager.SearchPathDirectory.documentDirectory
        
        let applicationDocumentsDirectory = FileManager.default.urls(for: directory, in: domains).first!
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        
        let storeURL = applicationDocumentsDirectory.appendingPathComponent("RetailStore.sqlite")
        
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext.undoManager = nil
        
        super.init()
    }
    
    func fetchCartItems(_ completionBlock: (([CartItem]) -> Void)!) {
        self.fetchEntriesWithPredicate({ entries in
            completionBlock(entries)
        })
    }
    func fetchEntriesWithPredicate(_ completionBlock: (([CartItem]) -> Void)!) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: "CartItem")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "productId", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        managedObjectContext.perform {
            let queryResults = try? self.managedObjectContext.fetch(fetchRequest)
            let managedResults = queryResults! as! [CartItem]
            
            self.cartItemsArray.accept(managedResults)
            //self.cartItemsArray.value = managedResults
            completionBlock(managedResults)
        }
    }
    
    //MARK: Database Operations
    func save() {
        do {
            try managedObjectContext.save()
        } catch let error {
            print("error: \(error)")
        }
    }
    
    func deleteObject(cartItem: CartItem) {
        managedObjectContext.delete(cartItem)
    }
    
    func discardMOCChanges() {
        managedObjectContext.rollback()
    }
    
    //MARK: Utility Methods
    func newCartItem() -> CartItem {
        let entity = CartItem(context: managedObjectContext)
        return entity
        
    }
    
    func checkForSimilarCartItemAndDelete(cartItemToCheck: CartItem) {
        for cartItem in self.cartItemsArray.value {
            if cartItem.productId == cartItemToCheck.productId && cartItemToCheck != cartItem {
                deleteObject(cartItem: cartItem)
            }
        }
    }
    
    func deleteCartItem(withProductId productId: Int16) {
        for cartItem in self.cartItemsArray.value {
            if cartItem.productId == productId {
                deleteObject(cartItem: cartItem)
                save()
                break;
            }
        }
    }
    
}
