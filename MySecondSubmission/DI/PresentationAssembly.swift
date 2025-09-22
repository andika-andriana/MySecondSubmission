import AboutFeature
import Common
import Core
import DetailFeature
import FavoritesFeature
import HomeFeature
import Swinject

final class PresentationAssembly: Assembly {
  func assemble(container: Container) {
    container.register(HomeViewModel.self) { resolver in
      MainActor.assumeIsolated {
        HomeViewModel(
          getGames: resolver.resolve((any GetGamesUseCase).self)!,
          searchGames: resolver.resolve((any SearchGamesUseCase).self)!
        )
      }
    }
    .inObjectScope(.transient)

    container.register(DetailViewModel.self) { resolver in
      MainActor.assumeIsolated {
        DetailViewModel(
          getDetail: resolver.resolve((any GetGameDetailUseCase).self)!,
          addFavorite: resolver.resolve((any AddFavoriteUseCase).self)!,
          removeFavorite: resolver.resolve((any RemoveFavoriteUseCase).self)!,
          observeFavorite: resolver.resolve((any ObserveFavoriteUseCase).self)!
        )
      }
    }
    .inObjectScope(.transient)

    container.register(FavoritesViewModel.self) { resolver in
      MainActor.assumeIsolated {
        FavoritesViewModel(
          getFavorites: resolver.resolve((any GetFavoritesUseCase).self)!,
          removeFavorite: resolver.resolve((any RemoveFavoriteUseCase).self)!
        )
      }
    }
    .inObjectScope(.transient)

    container.register(ProfileViewModel.self) { _ in
      MainActor.assumeIsolated {
        ProfileViewModel(manager: ProfileManager.shared)
      }
    }
    .inObjectScope(.transient)
  }
}
