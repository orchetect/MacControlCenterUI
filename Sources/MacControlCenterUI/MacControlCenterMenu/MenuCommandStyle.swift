//
//  MenuCommandStyle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// ``MacControlCenterMenu`` menu entry that acts like a traditional `NSMenuItem` that highlights
/// when moused over and is clickable with a custom action closure.
///
/// Menu hover colorization can be `menu` style (highlight color) or `commandCenter` style
/// (translucent grey).
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public enum MenuCommandStyle {
    /// Standard menu style (highlight on mouse hover using accent color)
    case menu
    
    /// Control Center style (highlight on mouse hover using translucent gray color)
    case controlCenter
}

extension MenuCommandStyle {
    public func textColor(hover: Bool) -> Color? {
        switch self {
        case .menu:
            return hover ? menuItemStandardHoverForeColor : nil
        case .controlCenter:
            return nil
        }
    }
    
    public func backColor(hover: Bool) -> Color? {
        switch self {
        case .menu:
            return hover ? menuItemStandardHoverBackColor : nil
        case .controlCenter:
            return hover ? menuItemControlCenterHoverBackColor : nil
        }
    }
}

extension MenuCommand {
    /// Apply a menu command style.
    public func menuCommandStyle(_ style: MenuCommandStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }
}
