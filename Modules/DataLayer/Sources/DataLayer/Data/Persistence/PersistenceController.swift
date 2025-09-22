import CoreData

#if !SWIFT_PACKAGE
  private final class PersistenceBundleFinder {}
#endif

public final class PersistenceController {
  public static let shared = PersistenceController()

  public let container: NSPersistentContainer

  public init(inMemory: Bool = false) {
    let bundle: Bundle
    #if SWIFT_PACKAGE
      bundle = .module
    #else
      bundle = Bundle(for: PersistenceBundleFinder.self)
    #endif

    guard
      let modelURL = bundle.url(
        forResource: PersistenceConstants.containerName,
        withExtension: "momd"
      ),
      let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
    else {
      fatalError(
        "Failed to locate Core Data model \(PersistenceConstants.containerName)"
      )
    }

    container = NSPersistentContainer(
      name: PersistenceConstants.containerName,
      managedObjectModel: managedObjectModel
    )

    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(
        fileURLWithPath: "/dev/null"
      )
    }

    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }

    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}
