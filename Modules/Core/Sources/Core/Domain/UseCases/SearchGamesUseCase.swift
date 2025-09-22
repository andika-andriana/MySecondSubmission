import Combine

public struct SearchGamesRequest: Equatable {
  public let query: String
  public let pageSize: Int

  public init(query: String, pageSize: Int) {
    self.query = query
    self.pageSize = pageSize
  }
}

public protocol SearchGamesUseCase: PublisherUseCase
where Request == SearchGamesRequest, Response == AnyPublisher<[Game], Error> {}

public struct DefaultSearchGamesUseCase: SearchGamesUseCase {
  private let repository: GameRepository

  public init(repository: GameRepository) {
    self.repository = repository
  }

  public func execute(_ request: SearchGamesRequest) -> AnyPublisher<
    [Game], Error
  > {
    repository.searchGames(query: request.query, pageSize: request.pageSize)
  }
}
