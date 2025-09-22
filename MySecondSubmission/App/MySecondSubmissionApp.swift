import AboutFeature
import Common
import FavoritesFeature
import HomeFeature
import SwiftUI

@main
struct MySecondSubmissionApp: App {
  @AppStorage("isDarkMode") private var isDarkMode = false
  @StateObject private var router = AppRouter()

  init() {
    ProfileManager.shared.registerDefaults()
  }

  var body: some Scene {
    WindowGroup {
      TabsView(
        homeViewModel: AppDI.resolver.resolve(HomeViewModel.self)!,
        favoritesViewModel: AppDI.resolver.resolve(FavoritesViewModel.self)!,
        profileViewModel: AppDI.resolver.resolve(ProfileViewModel.self)!
      )
      .environmentObject(router)
      .preferredColorScheme(isDarkMode ? .dark : .light)
    }
  }
}
