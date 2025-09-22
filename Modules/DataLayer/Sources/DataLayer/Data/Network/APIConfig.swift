//
//  APIConfig.swift
//  MySecondSubmission
//
//  Created by Andika Andriana on 07/09/25.
//

import Foundation

enum APIConfig {
  static var apiKey: String {
    do {
      return try Config.value(for: "RAWG_API_KEY")
    } catch {
      fatalError("❌ RAWG_API_KEY not found in Info.plist: \(error)")
    }
  }

  static var baseURL: URL {
    do {
      let raw: String = try Config.value(for: "RAWG_BASE_URL")
      guard let url = URL(string: "https://" + raw) else {
        fatalError("❌ RAWG_BASE_URL is invalid: \(raw)")
      }
      return url
    } catch {
      fatalError("❌ RAWG_BASE_URL not found in Info.plist: \(error)")
    }
  }
}
