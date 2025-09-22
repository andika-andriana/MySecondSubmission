import Combine

public protocol GetGamesUseCase: PublisherUseCase where Request == Int, Response == AnyPublisher<[Game], Error> {}

public struct DefaultGetGamesUseCase: GetGamesUseCase {
  private let repository: GameRepository

  public init(repository: GameRepository) {
    self.repository = repository
  }

  public func execute(_ request: Int) -> AnyPublisher<[Game], Error> {
    repository.fetchGames(pageSize: request)
  }
}
