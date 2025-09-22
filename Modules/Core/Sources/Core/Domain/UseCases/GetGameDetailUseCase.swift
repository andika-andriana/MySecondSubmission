import Combine

public protocol GetGameDetailUseCase: PublisherUseCase
where Request == Int, Response == AnyPublisher<Game, Error> {}

public struct DefaultGetGameDetailUseCase: GetGameDetailUseCase {
  private let repository: GameRepository

  public init(repository: GameRepository) {
    self.repository = repository
  }

  public func execute(_ request: Int) -> AnyPublisher<Game, Error> {
    repository.fetchDetail(id: request)
  }
}
