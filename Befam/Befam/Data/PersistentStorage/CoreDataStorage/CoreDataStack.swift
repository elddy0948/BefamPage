import CoreData

final class CoreDataStack {
  static let shared = CoreDataStack()
  
  lazy var managedContext: NSManagedObjectContext = {
    return self.persistentContainer.viewContext
  }()
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "ProductModel")
    container.loadPersistentStores(completionHandler: { _, error in
      if let error = error {
        fatalError(error.localizedDescription)
      }
    })
    return container
  }()
  
  private init() {}
  
  func saveContext() {
    guard managedContext.hasChanges else {
      return
    }
    do {
      try managedContext.save()
    } catch {
      print("Failed to save in CoreData : \(error.localizedDescription)")
    }
  }
}
