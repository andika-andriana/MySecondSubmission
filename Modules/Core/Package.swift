// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "Core",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "Core",
      targets: ["Core"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Core"
    ),
    .testTarget(
      name: "CoreTests",
      dependencies: ["Core"]
    ),
  ]
)
