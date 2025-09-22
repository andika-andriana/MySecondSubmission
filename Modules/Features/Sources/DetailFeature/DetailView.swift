import Common
import Core
import SwiftUI

public struct DetailView: View {
  @StateObject private var viewModel: DetailViewModel
  private let gameID: Int

  public init(gameID: Int, viewModel: DetailViewModel) {
    self.gameID = gameID
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        if let game = viewModel.game {
          TimedAsyncImage(
            urlString: game.imageURL?.absoluteString,
            timeout: 5,
            cornerRadius: 12,
            contentMode: .fill,
            frameWidth: nil,
            frameHeight: 200
          )

          Text(game.title)
            .font(.largeTitle)
            .fontWeight(.bold)

          if let rating = game.rating {
            HStack(spacing: 8) {
              Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
              Text(String(format: "%.1f", rating))
                .font(.headline)
            }
          }

          if let released = game.released {
            Text(CommonLocalization.string("detail.release"))
              .font(.caption)
              .foregroundStyle(.secondary)
            Text(released, style: .date)
          }

          if let description = game.descriptionRaw {
            Text(description)
              .font(.body)
          }
        } else if viewModel.isLoading {
          ProgressView()
            .frame(maxWidth: .infinity, alignment: .center)
        } else if let message = viewModel.errorMessage {
          ErrorStateView(
            message: message,
            retryKey: "action.retry"
          ) {
            viewModel.load(id: gameID)
          }
        }
      }
      .padding()
    }
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        Button {
          viewModel.toggleFavorite()
        } label: {
          Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
        }
        .accessibilityLabel(
          CommonLocalization.string(
            viewModel.isFavorite ? "a11y.unfavorite" : "a11y.favorite"
          )
        )
      }
    }
    .navigationTitle(CommonLocalization.string("detail.title"))
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      viewModel.load(id: gameID)
    }
  }
}
