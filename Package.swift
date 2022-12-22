// swift-tools-version:5.3
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "MacControlCenterUI",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "MacControlCenterUI",
            targets: ["MacControlCenterUI"]
        )
    ],
    dependencies: [
        // none
    ],
    targets: [
        .target(
            name: "MacControlCenterUI",
            dependencies: []
        ),
        .testTarget(
            name: "MacControlCenterUITests",
            dependencies: ["MacControlCenterUI"]
        )
    ]
)
