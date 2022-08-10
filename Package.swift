// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Hence",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "Hence",
      targets: ["Hence"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.38.3"),
  ],
  targets: [
    .target(
      name: "Hence",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "HenceTests",
      dependencies: ["Hence"]
    )
  ]
)
