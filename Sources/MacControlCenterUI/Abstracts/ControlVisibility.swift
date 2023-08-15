//
//  ControlVisibility.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

public enum ControlVisibility {
    /// Control is always visible.
    case always
    
    /// Control is visible while the mouse hovers.
    case onHover
}

#endif
