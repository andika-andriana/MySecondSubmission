import Core
import CoreData
import DataLayer
import Swinject
import SwinjectAutoregistration

final class DataAssembly: Assembly {
  func assemble(container: Container) {
    container.autoregister(RAWGAPIClientType.self, initializer: RAWGAPIClient.init)
      .inObjectScope(.container)

    container.register(PersistenceController.self) { _ in
      PersistenceController.shared
    }
    .inObjectScope(.container)

    container.register(NSManagedObjectContext.self) { resolver in
      resolver.resolve(PersistenceController.self)!.container.viewContext
    }
    .inObjectScope(.container)

    container.autoregister(GameRepository.self, initializer: GameRepositoryImpl.init)
      .inObjectScope(.container)

    container.register(FavoriteRepository.self) { resolver in
      FavoriteRepositoryImpl(context: resolver.resolve(NSManagedObjectContext.self)!)
    }
    .inObjectScope(.container)
  }
}
