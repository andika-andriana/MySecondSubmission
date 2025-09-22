import Combine
import Common
import Core
import Foundation

@MainActor
public final class DetailViewModel: ObservableObject {
  @Published public private(set) var game: Game?
  @Published public private(set) var isFavorite = false
  @Published public private(set) var isLoading = false
  @Published public private(set) var errorMessage: String?

  private let getDetail: any GetGameDetailUseCase
  private let addFavorite: any AddFavoriteUseCase
  private let removeFavorite: any RemoveFavoriteUseCase
  private let observeFavorite: any ObserveFavoriteUseCase
  private var cancellables = Set<AnyCancellable>()

  public init(
    getDetail: any GetGameDetailUseCase,
    addFavorite: any AddFavoriteUseCase,
    removeFavorite: any RemoveFavoriteUseCase,
    observeFavorite: any ObserveFavoriteUseCase
  ) {
    self.getDetail = getDetail
    self.addFavorite = addFavorite
    self.removeFavorite = removeFavorite
    self.observeFavorite = observeFavorite
  }

  public func load(id: Int) {
    isLoading = true
    errorMessage = nil

    getDetail.execute(id)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          guard let self else { return }
          self.isLoading = false
          if case .failure(let error) = completion {
            self.errorMessage = APIErrorMapper.message(for: error)
          }
        },
        receiveValue: { [weak self] game in
          guard let self else { return }
          self.game = game
          self.observeFavoriteStatus(id: game.id)
        }
      )
      .store(in: &cancellables)
  }

  private func observeFavoriteStatus(id: Int) {
    observeFavorite.execute(id)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isFavorite in
        self?.isFavorite = isFavorite
      }
      .store(in: &cancellables)
  }

  public func toggleFavorite() {
    guard let game else { return }

    let publisher: AnyPublisher<Void, Error>
    if isFavorite {
      publisher = removeFavorite.execute(game.id)
    } else {
      publisher = addFavorite.execute(game)
    }

    publisher
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          if case .failure(let error) = completion {
            self?.errorMessage = APIErrorMapper.message(for: error)
          }
        },
        receiveValue: { [weak self] in
          self?.isFavorite.toggle()
        }
      )
      .store(in: &cancellables)
  }
}
