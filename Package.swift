// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MacControlCenterUI",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "MacControlCenterUI", targets: ["MacControlCenterUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", from: "1.3.0")
    ],
    targets: [
        .target(name: "MacControlCenterUI", dependencies: ["MenuBarExtraAccess"])
    ]
)
