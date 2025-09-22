import Core
import Swinject
import SwinjectAutoregistration

final class DomainAssembly: Assembly {
  func assemble(container: Container) {
    container.autoregister(
      (any GetGamesUseCase).self,
      initializer: DefaultGetGamesUseCase.init
    )
    container.autoregister(
      (any SearchGamesUseCase).self,
      initializer: DefaultSearchGamesUseCase.init
    )
    container.autoregister(
      (any GetGameDetailUseCase).self,
      initializer: DefaultGetGameDetailUseCase.init
    )
    container.autoregister(
      (any GetFavoritesUseCase).self,
      initializer: DefaultGetFavoritesUseCase.init
    )
    container.autoregister(
      (any AddFavoriteUseCase).self,
      initializer: DefaultAddFavoriteUseCase.init
    )
    container.autoregister(
      (any RemoveFavoriteUseCase).self,
      initializer: DefaultRemoveFavoriteUseCase.init
    )
    container.autoregister(
      (any ObserveFavoriteUseCase).self,
      initializer: DefaultObserveFavoriteUseCase.init
    )
  }
}
