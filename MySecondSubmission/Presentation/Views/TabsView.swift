import AboutFeature
import Common
import DetailFeature
import FavoritesFeature
import HomeFeature
import SwiftUI

struct TabsView: View {
  let homeViewModel: HomeViewModel
  let favoritesViewModel: FavoritesViewModel
  let profileViewModel: ProfileViewModel

  @EnvironmentObject private var router: AppRouter

  var body: some View {
    TabView {
      NavigationStack(path: $router.path) {
        HomeView(viewModel: homeViewModel)
          .navigationDestination(for: AppRoute.self) { route in
            destination(for: route)
          }
      }
      .tabItem {
        Label(CommonLocalization.string("home.title"), systemImage: "house")
      }

      NavigationStack(path: $router.path) {
        FavoritesView(viewModel: favoritesViewModel)
          .navigationDestination(for: AppRoute.self) { route in
            destination(for: route)
          }
      }
      .tabItem {
        Label(
          CommonLocalization.string("favorites.title"),
          systemImage: "heart.fill"
        )
      }

      NavigationStack {
        AboutView(viewModel: profileViewModel)
      }
      .tabItem {
        Label(
          CommonLocalization.string("about.title"),
          systemImage: "person.crop.circle"
        )
      }
    }
  }

  @ViewBuilder
  private func destination(for route: AppRoute) -> some View {
    switch route {
    case .tabs:
      EmptyView()
        .onAppear {
          router.backToTabs()
        }
    case .detail(let id):
      if let vm = AppDI.resolver.resolve(DetailViewModel.self) {
        DetailView(gameID: id, viewModel: vm)
          .toolbar(.hidden, for: .tabBar)
      } else {
        EmptyView()
      }
    }
  }
}
