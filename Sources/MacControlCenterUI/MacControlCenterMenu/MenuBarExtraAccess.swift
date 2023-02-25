//
//  MenuBarExtraAccess.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit

/// Global static utility methods for interacting the app's menu bar extras (status items).
public enum MenuBarExtraAccess {
    /// Toggle MenuBarExtra menu/window presentation state.
    ///
    /// As of macOS Ventura 13.2, Xcode 14.2:
    /// There is no 1st-party API to dismiss or toggle the MenuBarExtra
    /// menu/window when using .menuBarExtraStyle(.window) style.
    ///
    /// The premise here is that we manually find the status item and sent it its own action.
    ///
    /// The most surefire way to access the NSStatusItem is to search for it every time,
    /// since we don't know fully what Apple's MenuBarExtra implementation does during its
    /// lifecycle.
    ///
    /// Radar FB11984872: https://github.com/feedback-assistant/reports/issues/383
    public static func togglePresented(index: Int = 0) {
        let statusItems = statusItems
        guard statusItems.indices.contains(index) else { return }
        
        let statusItem = statusItems[index]
        statusItem.togglePresented()
    }
    
    /// Returns the underlying status item(s) created by `MenuBarExtra`.
    ///
    /// Each `MenuBarExtra` creates one status item.
    ///
    /// If the `isInserted` binding on a `MenuBarExtra` is set to false, it may not return a status
    /// item. This may also change its index.
    public static var statusItems: [NSStatusItem] {
        NSApp.windows
            .filter {
                $0.className.contains("NSStatusBarWindow")
            }
            .compactMap { window -> NSStatusItem? in
                // On Macs with only one display, there should only be one result.
                // On Macs with two or more displays and system prefs set to "Displays have Separate
                // Spaces", one NSStatusBarWindow instance per display will be returned.
                // - the main/active instance has a statusItem property of type NSStatusItem
                // - the other(s) have a statusItem property of type NSStatusItemReplicant
                
                // NSStatusItemReplicant is a replica for displaying the status item on inactive
                // spaces/screens that happens to be an NSStatusItem subclass.
                // both respond to the action selector being sent to them.
                // We only need to interact with the main non-replica status item.
                guard let statusItem = window.fetchStatusItem(),
                      statusItem.className == "NSStatusItem"
                else { return nil }
                return statusItem
            }
    }
    
    /// Returns the underlying status items created by `MenuBarExtra` for the
    /// `MenuBarExtra` with the specified index.
    ///
    /// Each `MenuBarExtra` creates one status item.
    ///
    /// If the `isInserted` binding on a `MenuBarExtra` is set to false, it may not return a status
    /// item. This may also change its index.
    public static func statusItem(index: Int) -> NSStatusItem? {
        let statusItems = statusItems
        guard statusItems.indices.contains(index) else { return nil }
        return statusItems[index]
    }
}
