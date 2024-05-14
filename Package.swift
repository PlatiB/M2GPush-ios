// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "M2GPush",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "M2GPush",
            targets: ["M2GPush"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "M2GPush"),
        .testTarget(
            name: "M2GPushTests",
            dependencies: ["M2GPush"]),
    ]
)
