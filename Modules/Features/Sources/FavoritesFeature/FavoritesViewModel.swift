import Combine
import Common
import Core
import Foundation

@MainActor
public final class FavoritesViewModel: ObservableObject {
  @Published public private(set) var items: [Game] = []
  @Published public private(set) var isLoading = false
  @Published public private(set) var errorMessage: String?

  private let getFavorites: any GetFavoritesUseCase
  private let removeFavorite: any RemoveFavoriteUseCase
  private var cancellables = Set<AnyCancellable>()

  public init(
    getFavorites: any GetFavoritesUseCase,
    removeFavorite: any RemoveFavoriteUseCase
  ) {
    self.getFavorites = getFavorites
    self.removeFavorite = removeFavorite
  }

  public func load() {
    isLoading = true
    errorMessage = nil

    getFavorites.execute()
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          guard let self else { return }
          self.isLoading = false
          if case .failure(let error) = completion {
            self.errorMessage = APIErrorMapper.message(for: error)
          }
        },
        receiveValue: { [weak self] favorites in
          self?.items = favorites
        }
      )
      .store(in: &cancellables)
  }

  public func remove(id: Int) {
    removeFavorite.execute(id)
      .flatMap { [weak self] _ -> AnyPublisher<[Game], Error> in
        guard let self else {
          return Empty().eraseToAnyPublisher()
        }
        return self.getFavorites.execute()
      }
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          if case .failure(let error) = completion {
            self?.errorMessage = APIErrorMapper.message(for: error)
          }
        },
        receiveValue: { [weak self] favorites in
          self?.items = favorites
        }
      )
      .store(in: &cancellables)
  }
}
