//
//  MenuListStateItem.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Protocol to enable views to gain syntactic sugar when used within ``MenuList``.
public protocol MenuListStateItem {
    mutating func setState(state: Bool)
    mutating func setItemClicked(_ block: @escaping () -> Void)
}

#endif
