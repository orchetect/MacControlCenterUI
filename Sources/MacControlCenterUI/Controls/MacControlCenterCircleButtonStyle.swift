//
//  MacControlCenterCircleButtonStyle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

public enum MacControlCenterCircleButtonStyle {
    /// Standard Control Center Menu item size with trailing label.
    case menu
    
    /// Prominent size with bottom edge label.
    case prominent
    
    var size: CGFloat {
        switch self {
        case .menu: return 26
        case .prominent: return 38
        }
    }
    
    var imagePadding: CGFloat {
        switch self {
        case .menu: return 5
        case .prominent: return 10
        }
    }
}
