// swift-tools-version:5.3
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "MacControlCenterUI",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "MacControlCenterUI", targets: ["MacControlCenterUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", from: "1.2.2")
    ],
    targets: [
        .target(name: "MacControlCenterUI", dependencies: ["MenuBarExtraAccess"])
    ]
)
