import Core
import CoreData
import Foundation

extension FavoriteGame {
  func toDomain() -> Game {
    Game(
      id: Int(id),
      title: name ?? "-",
      rating: rating,
      imageURL: backgroundImage.flatMap(URL.init(string:)),
      released: released.flatMap { RAWGDate.ymd.date(from: $0) }
    )
  }

  func fill(from game: Game) {
    id = Int64(game.id)
    name = game.title
    rating = game.rating ?? 0
    backgroundImage = game.imageURL?.absoluteString
    released = game.released.map { RAWGDate.ymd.string(from: $0) }
  }
}
