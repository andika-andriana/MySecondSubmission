import Combine
import Core
import XCTest

// MARK: - Mocks
final class GameRepoMock: GameRepository {
  var games: [Game] = [
    Game(id: 1, title: "Test", rating: 4.2, imageURL: nil, released: nil)
  ]
  var detail: Game = Game(
    id: 1,
    title: "Detail",
    rating: 4.9,
    imageURL: nil,
    released: nil,
    descriptionRaw: "desc"
  )

  func fetchGames(pageSize: Int) -> AnyPublisher<[Game], Error> {
    Just(games).setFailureType(to: Error.self).eraseToAnyPublisher()
  }

  func searchGames(query: String, pageSize: Int) -> AnyPublisher<[Game], Error> {
    Just(games.filter { $0.title.localizedCaseInsensitiveContains(query) })
      .setFailureType(to: Error.self).eraseToAnyPublisher()
  }

  func fetchDetail(id: Int) -> AnyPublisher<Game, Error> {
    Just(detail).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
}

final class FavoriteRepoMock: FavoriteRepository {
  var store: [Int: Game] = [:]

  func list() -> AnyPublisher<[Game], Error> {
    Just(Array(store.values))
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }

  func add(_ game: Game) -> AnyPublisher<Void, Error> {
    store[game.id] = game
    return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
  }

  func remove(id: Int) -> AnyPublisher<Void, Error> {
    store[id] = nil
    return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
  }

  func exists(id: Int) -> AnyPublisher<Bool, Never> {
    Just(store[id] != nil).eraseToAnyPublisher()
  }
}

// MARK: - Tests
final class GetGamesUseCaseTests: XCTestCase {
  private var bag = Set<AnyCancellable>()

  func test_execute_returnsGames() {
    let repo = GameRepoMock()
    let sut = DefaultGetGamesUseCase(repository: repo)
    let exp = expectation(description: "returns games")

    sut.execute(10)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { games in
          XCTAssertEqual(games.count, 1)
          XCTAssertEqual(games.first?.title, "Test")
          exp.fulfill()
        }
      )
      .store(in: &bag)

    wait(for: [exp], timeout: 1)
  }
}

final class SearchGamesUseCaseTests: XCTestCase {
  private var bag = Set<AnyCancellable>()

  func test_execute_filtersByQuery() {
    let repo = GameRepoMock()
    repo.games = [
      Game(id: 1, title: "Zelda", rating: nil, imageURL: nil, released: nil),
      Game(id: 2, title: "Mario", rating: nil, imageURL: nil, released: nil)
    ]
    let sut = DefaultSearchGamesUseCase(repository: repo)
    let exp = expectation(description: "returns filtered")

    sut.execute(SearchGamesRequest(query: "zel", pageSize: 10))
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { games in
          XCTAssertEqual(games.map(\.title), ["Zelda"])
          exp.fulfill()
        }
      )
      .store(in: &bag)

    wait(for: [exp], timeout: 1)
  }
}

final class GetGameDetailUseCaseTests: XCTestCase {
  private var bag = Set<AnyCancellable>()

  func test_execute_returnsDetail() {
    let repo = GameRepoMock()
    repo.detail = Game(
      id: 99,
      title: "Detail",
      rating: 5.0,
      imageURL: nil,
      released: nil,
      descriptionRaw: "wow"
    )
    let sut = DefaultGetGameDetailUseCase(repository: repo)
    let exp = expectation(description: "returns detail")

    sut.execute(99)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { game in
          XCTAssertEqual(game.id, 99)
          XCTAssertEqual(game.descriptionRaw, "wow")
          exp.fulfill()
        }
      )
      .store(in: &bag)

    wait(for: [exp], timeout: 1)
  }
}

final class GetFavoritesUseCaseTests: XCTestCase {
  private var bag = Set<AnyCancellable>()

  func test_execute_listsFavorites() {
    let repo = FavoriteRepoMock()
    repo.store = [
      1: Game(id: 1, title: "Fav", rating: nil, imageURL: nil, released: nil)
    ]
    let sut = DefaultGetFavoritesUseCase(repository: repo)
    let exp = expectation(description: "lists favorites")

    sut.execute()
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { games in
          XCTAssertEqual(games.map(\.id), [1])
          exp.fulfill()
        }
      )
      .store(in: &bag)

    wait(for: [exp], timeout: 1)
  }
}

final class FavoriteUseCasesTests: XCTestCase {
  private var bag = Set<AnyCancellable>()

  func test_add_remove_and_observe() {
    let repo = FavoriteRepoMock()
    let add = DefaultAddFavoriteUseCase(repository: repo)
    let remove = DefaultRemoveFavoriteUseCase(repository: repo)
    let observe = DefaultObserveFavoriteUseCase(repository: repo)
    let game = Game(id: 7, title: "Seven", rating: nil, imageURL: nil, released: nil)

    let addExp = expectation(description: "add")
    add.execute(game)
      .sink(receiveCompletion: { _ in }, receiveValue: { addExp.fulfill() })
      .store(in: &bag)
    wait(for: [addExp], timeout: 1)

    let observeExp = expectation(description: "observe true")
    observe.execute(7)
      .sink { isFavorite in
        XCTAssertTrue(isFavorite)
        observeExp.fulfill()
      }
      .store(in: &bag)

    let removeExp = expectation(description: "remove")
    remove.execute(7)
      .sink(receiveCompletion: { _ in }, receiveValue: { removeExp.fulfill() })
      .store(in: &bag)

    wait(for: [observeExp, removeExp], timeout: 1)

    let observeFalseExp = expectation(description: "observe false")
    observe.execute(7)
      .sink { isFavorite in
        XCTAssertFalse(isFavorite)
        observeFalseExp.fulfill()
      }
      .store(in: &bag)

    wait(for: [observeFalseExp], timeout: 1)
  }
}
