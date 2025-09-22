//
//  Game.swift
//  MySecondSubmission
//
//  Created by Andika Andriana on 14/09/25.
//

import Foundation

public struct Game: Identifiable, Equatable {
  public let id: Int
  public let title: String
  public let rating: Double?
  public let imageURL: URL?
  public let released: Date?
  public let descriptionRaw: String?

  public init(
    id: Int,
    title: String,
    rating: Double?,
    imageURL: URL?,
    released: Date?,
    descriptionRaw: String? = nil
  ) {
    self.id = id
    self.title = title
    self.rating = rating
    self.imageURL = imageURL
    self.released = released
    self.descriptionRaw = descriptionRaw
  }
}
