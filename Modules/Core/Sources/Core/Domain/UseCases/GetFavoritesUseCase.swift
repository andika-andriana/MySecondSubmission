import Combine

public protocol GetFavoritesUseCase: PublisherUseCase
where Request == Void, Response == AnyPublisher<[Game], Error> {}

public struct DefaultGetFavoritesUseCase: GetFavoritesUseCase {
  private let repository: FavoriteRepository

  public init(repository: FavoriteRepository) {
    self.repository = repository
  }

  public func execute(_ request: Void) -> AnyPublisher<[Game], Error> {
    repository.list()
  }
}
