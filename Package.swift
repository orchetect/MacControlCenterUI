// swift-tools-version: 5.5
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "MacControlCenterSlider",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "MacControlCenterSlider",
            targets: ["MacControlCenterSlider"]
        )
    ],
    dependencies: [
        // none
    ],
    targets: [
        .target(
            name: "MacControlCenterSlider",
            dependencies: []
        ),
        .testTarget(
            name: "MacControlCenterSliderTests",
            dependencies: ["MacControlCenterSlider"]
        )
    ]
)
