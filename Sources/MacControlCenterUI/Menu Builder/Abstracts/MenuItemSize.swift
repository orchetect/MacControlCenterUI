//
//  MenuItemSize.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// ``MacControlCenterMenu`` menu item size.
public enum MenuItemSize: Equatable, Hashable {
    /// Standard height for text-only menu items.
    /// This equates to traditional NSMenu-style item height.
    case standardTextOnly
    
    /// Standard height for Control Center menu items that contain an icon/image.
    case controlCenterIconItem
    
    /// Standard height for Control Center section labels.
    case controlCenterSection
    
    /// Specify a custom size.
    case custom(CGFloat)
}

extension MenuItemSize {
    /// The inner padded content height.
    public var contentHeight: CGFloat {
        switch self {
        case .standardTextOnly:
            return MenuGeometry.menuItemContentStandardHeight + MenuGeometry.menuItemPadding
        case .controlCenterIconItem:
            return MenuCircleButtonSize.menu.size + MenuGeometry.menuItemPadding
        case .controlCenterSection:
            return 20
        case .custom(let value):
            return value
        }
    }
    
    /// The non-padded bounds height of the menu item.
    public var boundsHeight: CGFloat {
        switch self {
        case .custom(let value):
            return value
        default:
            return contentHeight + MenuGeometry.menuVerticalPadding
        }
    }
}
