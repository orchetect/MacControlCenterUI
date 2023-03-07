//
//  MenuCommandStyle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Style for ``MenuCommand``.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public enum MenuCommandStyle {
    /// Standard menu style (highlight on mouse hover using accent color).
    case menu
    
    /// Control Center style (highlight on mouse hover using translucent gray color).
    case controlCenter
}

extension MenuCommandStyle {
    public func textColor(hover: Bool) -> Color? {
        guard hover else { return nil }
        
        switch self {
        case .menu:
            return MenuGeometry.menuItemStandardHoverForeColor
        case .controlCenter:
            return nil
        }
    }
    
    public func backColor(hover: Bool, for colorScheme: ColorScheme) -> Color? {
        guard hover else { return nil }
        
        switch self {
        case .menu:
            return MenuGeometry.menuItemStandardHoverBackColor
        case .controlCenter:
            if colorScheme == .dark {
                return Color(white: 0.3, opacity: 0.4)
            } else {
                return Color(white: 0.9, opacity: 0.2)
            }
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
