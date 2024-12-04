//
//  Utilities.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

/// Returns the icon image for the application with the given bundle ID.
/// If the application does not exist or cannot be found, a blank image placeholder is returned.
func appIcon(for bundleID: String) -> Image {
    if let bundle = Bundle(identifier: bundleID),
       let iconName = bundle.infoDictionary?["CFBundleIconFile"] as? String,
       let icon = bundle.image(forResource: iconName)
    {
        return Image(nsImage: icon)
    } else if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID),
              let bundle = Bundle(url: appURL),
              let iconName = bundle.infoDictionary?["CFBundleIconFile"] as? String,
              let icon = bundle.image(forResource: iconName)
    {
        return Image(nsImage: icon)
    } else if let defaultIcon = NSImage(systemSymbolName: "app", accessibilityDescription: nil) {
        return Image(nsImage: defaultIcon)
    } else {
        return Image(systemName: "square")
    }
}
