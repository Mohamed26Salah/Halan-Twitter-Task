// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HalanTwitterRepositories",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HalanTwitterRepositories",
            targets: ["HalanTwitterRepositories"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", from: "2.5.3"),
        .package(path: "../../HalanTwitterUseCases"),
        .package(path: "../TwitterManager")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HalanTwitterRepositories",
            dependencies: [
                .product(name: "Factory", package: "Factory"),
                .product(name: "TwitterManager", package: "TwitterManager"),
                .product(name: "HalanTwitterUseCases", package: "HalanTwitterUseCases")
            ]
        ),
        .testTarget(
            name: "HalanTwitterRepositoriesTests",
            dependencies: ["HalanTwitterRepositories"]
        ),
    ]
)
