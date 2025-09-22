// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "Features",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(name: "HomeFeature", targets: ["HomeFeature"]),
    .library(name: "DetailFeature", targets: ["DetailFeature"]),
    .library(name: "FavoritesFeature", targets: ["FavoritesFeature"]),
    .library(name: "AboutFeature", targets: ["AboutFeature"])
  ],
  dependencies: [
    .package(path: "../Core"),
    .package(url: "https://github.com/andika-andriana/Modularization-Common-Package.git", branch: "main")
  ],
  targets: [
    .target(
      name: "HomeFeature",
      dependencies: [
        .product(name: "Core", package: "Core"),
        .product(name: "Common", package: "Modularization-Common-Package")
      ]
    ),
    .testTarget(
      name: "HomeFeatureTests",
      dependencies: ["HomeFeature"]
    ),
    .target(
      name: "DetailFeature",
      dependencies: [
        .product(name: "Core", package: "Core"),
        .product(name: "Common", package: "Modularization-Common-Package")
      ]
    ),
    .testTarget(
      name: "DetailFeatureTests",
      dependencies: ["DetailFeature"]
    ),
    .target(
      name: "FavoritesFeature",
      dependencies: [
        .product(name: "Core", package: "Core"),
        .product(name: "Common", package: "Modularization-Common-Package")
      ]
    ),
    .testTarget(
      name: "FavoritesFeatureTests",
      dependencies: ["FavoritesFeature"]
    ),
    .target(
      name: "AboutFeature",
      dependencies: [
        .product(name: "Core", package: "Core"),
        .product(name: "Common", package: "Modularization-Common-Package")
      ]
    ),
    .testTarget(
      name: "AboutFeatureTests",
      dependencies: ["AboutFeature"]
    )
  ]
)
