import Combine
import Core

public final class GameRepositoryImpl: GameRepository {
  private let apiClient: RAWGAPIClientType

  public init(apiClient: RAWGAPIClientType) {
    self.apiClient = apiClient
  }

  public func fetchGames(pageSize: Int) -> AnyPublisher<[Game], Error> {
    apiClient.fetchGames(pageSize: pageSize)
  }

  public func searchGames(query: String, pageSize: Int) -> AnyPublisher<
    [Game], Error
  > {
    apiClient.searchGames(query: query, pageSize: pageSize)
  }

  public func fetchDetail(id: Int) -> AnyPublisher<Game, Error> {
    apiClient.fetchGameDetail(id: id)
  }
}
