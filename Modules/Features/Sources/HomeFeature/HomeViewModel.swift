import Combine
import Common
import Core
import Foundation

@MainActor
public final class HomeViewModel: ObservableObject {
  @Published public private(set) var games: [Game] = []
  @Published public private(set) var isLoading = false
  @Published public private(set) var errorMessage: String?

  private let getGames: any GetGamesUseCase
  private let searchGames: any SearchGamesUseCase
  private var cancellables = Set<AnyCancellable>()
  private let defaultPageSize: Int

  public init(
    getGames: any GetGamesUseCase,
    searchGames: any SearchGamesUseCase,
    defaultPageSize: Int = 10
  ) {
    self.getGames = getGames
    self.searchGames = searchGames
    self.defaultPageSize = defaultPageSize
  }

  public func load() {
    isLoading = true
    errorMessage = nil

    getGames.execute(defaultPageSize)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          guard let self else { return }
          self.isLoading = false
          if case .failure(let error) = completion {
            self.errorMessage = APIErrorMapper.message(for: error)
          }
        },
        receiveValue: { [weak self] games in
          self?.games = games
        }
      )
      .store(in: &cancellables)
  }

  public func search(_ query: String) {
    guard !query.isEmpty else {
      load()
      return
    }

    isLoading = true
    errorMessage = nil

    let request = SearchGamesRequest(query: query, pageSize: defaultPageSize)

    searchGames.execute(request)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          guard let self else { return }
          self.isLoading = false
          if case .failure(let error) = completion {
            self.errorMessage = APIErrorMapper.message(for: error)
          }
        },
        receiveValue: { [weak self] games in
          self?.games = games
        }
      )
      .store(in: &cancellables)
  }
}
