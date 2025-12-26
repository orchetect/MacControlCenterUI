//
//  MenuItemSize.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// ``MacControlCenterMenu`` menu item size.
nonisolated
public enum MenuItemSize {
    /// Standard height for text-only menu items.
    /// This equates to traditional NSMenu-style item height.
    case standardTextOnly
    
    /// Standard height for Control Center menu items that contain an icon/image.
    case controlCenterIconItem
    
    /// Standard height for Control Center section labels.
    case controlCenterSection
    
    /// Specify a custom size.
    case custom(CGFloat, verticalPadding: Bool = true)
    
    /// Automatically size the menu item.
    case auto(verticalPadding: Bool = true)
}

extension MenuItemSize: Equatable { }

extension MenuItemSize: Hashable { }

extension MenuItemSize: Sendable { }

// MARK: - Static Constructors

extension MenuItemSize {
    /// Automatically size the menu item.
    public static var auto: Self { .auto() }
}

// MARK: - Properties

extension MenuItemSize {
    /// The inner content height portion of the ``boundsHeight`` (without padding).
    public var contentHeight: CGFloat? {
        switch self {
        case .standardTextOnly:
            return MenuGeometry.menuItemContentStandardHeight
        case .controlCenterIconItem:
            return MenuCircleButtonSize.menu.size
        case .controlCenterSection:
            return 20
        case let .custom(value, verticalPadding: _):
            return value
        case .auto(verticalPadding: _):
            return nil
        }
    }
    
    /// Returns the padding portion of the ``boundsHeight`` (without inner content).
    public var paddingHeight: CGFloat {
        switch self {
        case .standardTextOnly:
            return MenuGeometry.menuItemPadding
        case .controlCenterIconItem:
            return MenuGeometry.menuItemPadding
        case .controlCenterSection:
            return 0
        case let .custom(_, verticalPadding: verticalPadding):
            return verticalPadding ? MenuGeometry.menuItemPadding : 0
        case let .auto(verticalPadding: verticalPadding):
            return verticalPadding ? MenuGeometry.menuItemPadding : 0
        }
    }
    
    /// The full bounds height of the menu item, including padding.
    public var boundsHeight: CGFloat? {
        guard let contentHeight else { return nil }
        return contentHeight + paddingHeight
    }
}

#endif
