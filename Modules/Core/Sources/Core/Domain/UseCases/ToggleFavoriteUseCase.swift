import Combine

public protocol AddFavoriteUseCase: PublisherUseCase
where Request == Game, Response == AnyPublisher<Void, Error> {}
public protocol RemoveFavoriteUseCase: PublisherUseCase
where Request == Int, Response == AnyPublisher<Void, Error> {}
public protocol ObserveFavoriteUseCase: PublisherUseCase
where Request == Int, Response == AnyPublisher<Bool, Never> {}

public struct DefaultAddFavoriteUseCase: AddFavoriteUseCase {
  private let repository: FavoriteRepository

  public init(repository: FavoriteRepository) {
    self.repository = repository
  }

  public func execute(_ request: Game) -> AnyPublisher<Void, Error> {
    repository.add(request)
  }
}

public struct DefaultRemoveFavoriteUseCase: RemoveFavoriteUseCase {
  private let repository: FavoriteRepository

  public init(repository: FavoriteRepository) {
    self.repository = repository
  }

  public func execute(_ request: Int) -> AnyPublisher<Void, Error> {
    repository.remove(id: request)
  }
}

public struct DefaultObserveFavoriteUseCase: ObserveFavoriteUseCase {
  private let repository: FavoriteRepository

  public init(repository: FavoriteRepository) {
    self.repository = repository
  }

  public func execute(_ request: Int) -> AnyPublisher<Bool, Never> {
    repository.exists(id: request)
  }
}
