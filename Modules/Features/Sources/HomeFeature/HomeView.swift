import Common
import Core
import SwiftUI

public struct HomeView: View {
  @AppStorage("isDarkMode") private var isDarkMode = false
  @StateObject private var viewModel: HomeViewModel
  @State private var query = ""

  public init(viewModel: HomeViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    if #available(iOS 17.0, *) {
      List(viewModel.games) { game in
        if #available(iOS 16.0, *) {
          NavigationLink(value: AppRoute.detail(game.id)) {
            GameRow(game: game)
          }
        } else {
          // Fallback on earlier versions
        }
      }
      .listStyle(.plain)
      .searchable(
        text: $query,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: CommonLocalization.text("search.prompt")
      )
      .onChange(of: query) { _, newValue in
        viewModel.search(newValue)
      }
      .onAppear {
        if viewModel.games.isEmpty {
          viewModel.load()
        }
      }
      .overlay {
        if viewModel.isLoading {
          ProgressView(CommonLocalization.string("home.loading"))
            .progressViewStyle(.circular)
        } else if let message = viewModel.errorMessage {
          ErrorStateView(
            message: message,
            retryKey: "action.retry"
          ) {
            viewModel.load()
          }
        }
      }
      .navigationTitle(CommonLocalization.string("home.app"))
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
          Button {
            isDarkMode.toggle()
          } label: {
            Image(systemName: isDarkMode ? "moon.fill" : "sun.max")
          }
          .accessibilityLabel(
            CommonLocalization.string(
              isDarkMode ? "a11y.darkmode.off" : "a11y.darkmode.on"
            )
          )
        }
      }
    } else {
      // Fallback on earlier versions
    }
  }
}

private struct GameRow: View {
  let game: Game

  var body: some View {
    HStack(alignment: .top) {
      TimedAsyncImage(
        urlString: game.imageURL?.absoluteString,
        timeout: 5,
        cornerRadius: 8,
        contentMode: .fill,
        frameWidth: 80,
        frameHeight: 80
      )
      VStack(alignment: .leading, spacing: 4) {
        Text(game.title)
          .font(.headline)
        if let releaseDate = game.released {
          HStack(spacing: 4) {
            Text(CommonLocalization.string("label.release"))
            Text(releaseDate, style: .date)
          }
          .font(.subheadline)
          .foregroundColor(.secondary)
        }
        HStack {
          Image(systemName: "star.fill")
            .foregroundColor(.yellow)
          Text(String(format: "%.1f", game.rating ?? 0.0))
            .font(.subheadline)
        }
      }
    }
    .padding(.vertical, 4)
  }
}
