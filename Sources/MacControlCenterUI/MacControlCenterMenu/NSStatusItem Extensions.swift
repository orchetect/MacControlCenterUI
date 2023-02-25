//
//  NSStatusItem Extensions.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension NSStatusItem {
    /// Toggles the menu/window state by mimicking a menu item button press.
    @_disfavoredOverload
    public func togglePresented() {
        // mimic user pressing the menu item button
        // which convinces MenuBarExtra to close the window and properly reset its state
        let actionSelector = button?.action // toggleWindow:
        button?.sendAction(actionSelector, to: button?.target)
    }
}

extension NSWindow {
    /// If the window belongs to a status item, returns the associated `NSStatusItem`.
    @_disfavoredOverload
    public func fetchStatusItem() -> NSStatusItem? {
        guard let statusItem = value(forKey: "statusItem") as? NSStatusItem
        else { return nil }
        return statusItem
    }
}
