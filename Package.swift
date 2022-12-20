// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "MacControlCenterSlider",
    products: [
        .library(
            name: "MacControlCenterSlider",
            targets: ["MacControlCenterSlider"]),
    ],
    dependencies: [
        // none
    ],
    targets: [
        .target(
            name: "MacControlCenterSlider",
            dependencies: []),
        .testTarget(
            name: "MacControlCenterSliderTests",
            dependencies: ["MacControlCenterSlider"]),
    ]
)
