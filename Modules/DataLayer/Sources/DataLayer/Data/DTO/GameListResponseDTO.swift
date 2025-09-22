//
//  GameListResponseDTO.swift
//  MySecondSubmission
//
//  Created by Andika Andriana on 14/09/25.
//

import Foundation

struct GameListResponseDTO: Decodable {
  let results: [GameDTO]
}
