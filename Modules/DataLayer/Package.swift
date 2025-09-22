// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "DataLayer",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "DataLayer",
      targets: ["DataLayer"]
    )
  ],
  dependencies: [
    .package(path: "../Core"),
    .package(
      url:
        "https://github.com/andika-andriana/Modularization-Common-Package.git",
      branch: "main"
    ),
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.2"),
  ],
  targets: [
    .target(
      name: "DataLayer",
      dependencies: [
        .product(name: "Core", package: "Core"),
        .product(name: "Common", package: "Modularization-Common-Package"),
        .product(name: "Alamofire", package: "Alamofire"),
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .testTarget(
      name: "DataLayerTests",
      dependencies: ["DataLayer"]
    ),
  ]
)
