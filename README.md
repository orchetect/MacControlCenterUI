# Mac Control Center UI

[![Platforms - macOS 11+](https://img.shields.io/badge/platforms-macOS%2011+-lightgrey.svg?style=flat)](https://developer.apple.com/swift) ![Swift 5.3-5.8](https://img.shields.io/badge/Swift-5.3–5.8-orange.svg?style=flat) [![Xcode 13-14](https://img.shields.io/badge/Xcode-13–14-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/MacControlCenterUI/blob/main/LICENSE)

<img align="right" width="40%" src="Images/demo.png" alt="Example">



A **menu builder** and **suite of SwiftUI controls** that closely mimic the feel of **macOS Control Center** menus.

Integrates seamlessly with Swift's new `MenuBarExtra`.

Both **Dark** and **Light Mode** are fully supported.

## Getting Started

### Swift Package Manager (SPM)

1. Add MacControlCenterUI as a dependency using Swift Package Manager.

   - In an app project or framework, in Xcode:

     Select the menu: **File → Swift Packages → Add Package Dependency...**

     Enter this URL: `https://github.com/orchetect/MacControlCenterUI`

   - In a Swift Package, add it to the Package.swift dependencies:

     ```swift
     .package(url: "https://github.com/orchetect/MacControlCenterUI", from: "2.0.0")
     ```

2. Import the library:

   ```swift
   import MacControlCenterUI
   ```

3. Try the [Demo](Demo) example project to see all of the available controls in action.

## Requirements

Minimum requirements to compile: Xcode 13 on macOS 11 Big Sur or newer.

Supports macOS 11.0+ once compiled.

## Known Issues

Due to the lacklustre implementation of Apple's `MenuBarExtra`, it is currently not possible to get smooth window resize animations without a tremendous amount of work. For that reason, most MacControlCenterUI controls whose Control Center counterparts use animation will instead use safer static view size changes.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/MacControlCenterUI/blob/master/LICENSE) for details.

## Sponsoring

If you enjoy using MacControlCenterUI and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/MacControlCenterUI/discussions) first prior to new submitting PRs for features or modifications is encouraged.
