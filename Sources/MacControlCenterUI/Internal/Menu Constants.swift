//
//  Menu Constants.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

enum MenuGeometry {
    static let menuItemStandardHoverForeColor = Color(NSColor.selectedMenuItemTextColor)
    static let menuItemStandardHoverBackColor = Color(NSColor.selectedContentBackgroundColor)
    
    static let menuHorizontalContentInset: CGFloat = 14
    static let menuHorizontalHighlightInset: CGFloat = 4
    static let menuVerticalPadding: CGFloat = 1
    static let menuItemPadding: CGFloat = 4
    static let menuItemContentStandardHeight: CGFloat = 18
    static let menuPadding: CGFloat = 6
}

enum MenuStyling {
    static let headerFontSize: CGFloat = 13
}

#endif
