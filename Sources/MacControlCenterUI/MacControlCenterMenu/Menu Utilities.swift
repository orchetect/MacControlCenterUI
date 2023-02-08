//
//  Menu Utilities.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

// MARK: - Menu Item Protocol

public protocol MacControlCenterMenuItem { }

// MARK: - Geometry

let menuItemStandardHoverForeColor = Color(NSColor.selectedMenuItemTextColor)
let menuItemStandardHoverBackColor = Color(NSColor.selectedContentBackgroundColor)

let menuItemControlCenterHoverBackColor = Color(white: 0.4, opacity: 0.7)

let menuHorizontalContentInset: CGFloat = 14
let menuHorizontalHighlightInset: CGFloat = 4
let menuVerticalPadding: CGFloat = 1
let menuItemPadding: CGFloat = 4
let menuItemContentStandardHeight: CGFloat = 18
let menuPadding: CGFloat = 6
