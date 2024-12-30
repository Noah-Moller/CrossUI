// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CrossUI",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CrossUI",
            targets: ["CrossUI"]),
        
            .executable(name: "cross", targets: ["crossui-cli"]),
    ],
    targets: [
        .target(
            name: "CrossUI",
            dependencies: [],
            path: "Sources/CrossUI"
        ),
        .executableTarget(
            name: "crossui-cli",
            dependencies: ["CrossUI"],
            path: "Sources/crossui-cli"
        ),
        .testTarget(
            name: "CrossUITests",
            dependencies: ["CrossUI"]
        )
    ]
)
