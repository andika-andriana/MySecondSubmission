//
//  GameDTO.swift
//  MySecondSubmission
//
//  Created by Andika Andriana on 14/09/25.
//

import Foundation

struct GameDTO: Decodable {
  let id: Int
  let name: String?
  let rating: Double?
  let backgroundImage: String?
  let released: String?
  let descriptionRaw: String?

  enum CodingKeys: String, CodingKey {
    case id, name, rating, released
    case backgroundImage = "background_image"
    case descriptionRaw = "description_raw"
  }
}
