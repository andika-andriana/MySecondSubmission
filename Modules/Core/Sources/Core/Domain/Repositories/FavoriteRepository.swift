//
//  FavoriteRepository.swift
//  MySecondSubmission
//
//  Created by Andika Andriana on 14/09/25.
//

import Combine

public protocol FavoriteRepository {
  func list() -> AnyPublisher<[Game], Error>
  func add(_ game: Game) -> AnyPublisher<Void, Error>
  func remove(id: Int) -> AnyPublisher<Void, Error>
  func exists(id: Int) -> AnyPublisher<Bool, Never>
}
