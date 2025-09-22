import Alamofire
import Combine
import Core
import Foundation

public protocol RAWGAPIClientType {
  func fetchGames(pageSize: Int) -> AnyPublisher<[Game], Error>
  func searchGames(query: String, pageSize: Int) -> AnyPublisher<[Game], Error>
  func fetchGameDetail(id: Int) -> AnyPublisher<Game, Error>
}

public final class RAWGAPIClient: RAWGAPIClientType {
  public init() {}

  public func fetchGames(pageSize: Int) -> AnyPublisher<[Game], Error> {
    guard
      let url = RAWGURLBuilder.makeURL(
        path: "/api/games",
        queries: [URLQueryItem(name: "page_size", value: "\(pageSize)")]
      )
    else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }

    return AF.request(url)
      .validate(statusCode: 200..<300)
      .publishDecodable(type: GameListResponseDTO.self)
      .value()
      .map { $0.results.map { $0.toDomain() } }
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }

  public func searchGames(query: String, pageSize: Int) -> AnyPublisher<[Game], Error> {
    guard
      let url = RAWGURLBuilder.makeURL(
        path: "/api/games",
        queries: [
          URLQueryItem(name: "page_size", value: "\(pageSize)"),
          URLQueryItem(name: "search", value: query)
        ]
      )
    else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }

    return AF.request(url)
      .validate(statusCode: 200..<300)
      .publishDecodable(type: GameListResponseDTO.self)
      .value()
      .map { $0.results.map { $0.toDomain() } }
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }

  public func fetchGameDetail(id: Int) -> AnyPublisher<Game, Error> {
    guard let url = RAWGURLBuilder.makeURL(path: "/api/games/\(id)")
    else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }

    return AF.request(url)
      .validate(statusCode: 200..<300)
      .publishDecodable(type: GameDTO.self)
      .value()
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}
