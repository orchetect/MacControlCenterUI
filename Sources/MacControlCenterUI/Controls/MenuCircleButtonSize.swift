//
//  MenuCircleButtonSize.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Control size for ``MenuCircleToggle`` and ``MenuCircleButton``.
public enum MenuCircleButtonSize {
    /// Standard Control Center Menu item size with trailing label.
    case menu
    
    /// Prominent size with bottom edge label.
    case prominent
    
    public var size: CGFloat {
        switch self {
        case .menu: return 26
        case .prominent: return 38
        }
    }
    
    public var imagePadding: CGFloat {
        switch self {
        case .menu: return 5
        case .prominent: return 10
        }
    }
}
