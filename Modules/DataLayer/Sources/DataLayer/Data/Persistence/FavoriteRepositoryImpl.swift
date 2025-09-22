import Combine
import Core
import CoreData

public final class FavoriteRepositoryImpl: FavoriteRepository {
  private let context: NSManagedObjectContext

  public init(context: NSManagedObjectContext) {
    self.context = context
  }

  public func list() -> AnyPublisher<[Game], Error> {
    Future { [context] promise in
      context.perform {
        do {
          let request: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
          let items = try context.fetch(request).map { $0.toDomain() }
          promise(.success(items))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  public func add(_ game: Game) -> AnyPublisher<Void, Error> {
    Future { [context] promise in
      context.perform {
        do {
          let favorite = FavoriteGame(context: context)
          favorite.fill(from: game)
          try context.save()
          promise(.success(()))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  public func remove(id: Int) -> AnyPublisher<Void, Error> {
    Future { [context] promise in
      context.perform {
        do {
          let request: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
          request.predicate = NSPredicate(format: "id == %lld", id)
          if let object = try context.fetch(request).first {
            context.delete(object)
          }
          try context.save()
          promise(.success(()))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  public func exists(id: Int) -> AnyPublisher<Bool, Never> {
    Future { [context] promise in
      context.perform {
        let request: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", id)
        let count = (try? context.count(for: request)) ?? 0
        promise(.success(count > 0))
      }
    }
    .eraseToAnyPublisher()
  }
}
