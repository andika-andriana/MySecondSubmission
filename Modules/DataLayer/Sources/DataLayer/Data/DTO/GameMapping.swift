import Core
import Foundation

enum RAWGDate {
  static let ymd: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
}

extension GameDTO {
  func toDomain() -> Game {
    let url = backgroundImage.flatMap(URL.init(string:))
    let date = released.flatMap { RAWGDate.ymd.date(from: $0) }
    return Game(
      id: id,
      title: name ?? "-",
      rating: rating,
      imageURL: url,
      released: date,
      descriptionRaw: descriptionRaw
    )
  }
}
