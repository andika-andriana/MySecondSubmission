import Common
import Core
import SwiftUI

@available(iOS 16.0, *)
public struct FavoritesView: View {
  @StateObject private var viewModel: FavoritesViewModel

  public init(viewModel: FavoritesViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    List {
      ForEach(viewModel.items) { game in
        NavigationLink(value: AppRoute.detail(game.id)) {
          FavoriteRow(game: game)
        }
        .swipeActions {
          Button(role: .destructive) {
            viewModel.remove(id: game.id)
          } label: {
            Label(
              CommonLocalization.string("favorites.remove"),
              systemImage: "trash"
            )
          }
        }
      }
    }
    .listStyle(.plain)
    .overlay {
      if viewModel.isLoading {
        ProgressView(CommonLocalization.string("favorites.loading"))
      } else if let message = viewModel.errorMessage {
        ErrorStateView(
          message: message,
          retryKey: "action.retry"
        ) {
          viewModel.load()
        }
      } else if viewModel.items.isEmpty {
        EmptyStateView(
          title: CommonLocalization.string("favorites.empty.title"),
          subtitle: CommonLocalization.string("favorites.empty.subtitle"),
          systemImage: "heart.slash"
        )
      }
    }
    .navigationTitle(CommonLocalization.string("favorites.title"))
    .onAppear { viewModel.load() }
  }
}

private struct FavoriteRow: View {
  let game: Game

  var body: some View {
    HStack(alignment: .center) {
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
          Text(releaseDate, style: .date)
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
    }
    .padding(.vertical, 4)
  }
}

private struct EmptyStateView: View {
  let title: String
  let subtitle: String
  let systemImage: String

  var body: some View {
    VStack(spacing: 12) {
      Image(systemName: systemImage)
        .font(.system(size: 48))
        .foregroundColor(.secondary)
      Text(title)
        .font(.headline)
      Text(subtitle)
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
    }
    .padding()
  }
}
