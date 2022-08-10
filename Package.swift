// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Hence",
  products: [
    .library(
      name: "Hence",
      targets: ["Hence"]
    )
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "Hence",
      dependencies: []
    ),
    .testTarget(
      name: "HenceTests",
      dependencies: ["Hence"]
    )
  ]
)
