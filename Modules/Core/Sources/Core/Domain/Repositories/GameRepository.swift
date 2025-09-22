//
//  GameRepository.swift
//  MySecondSubmission
//
//  Created by Andika Andriana on 14/09/25.
//

import Combine

public protocol GameRepository {
  func fetchGames(pageSize: Int) -> AnyPublisher<[Game], Error>
  func searchGames(query: String, pageSize: Int) -> AnyPublisher<[Game], Error>
  func fetchDetail(id: Int) -> AnyPublisher<Game, Error>
}
