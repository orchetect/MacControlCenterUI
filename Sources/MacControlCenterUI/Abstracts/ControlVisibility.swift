//
//  ControlVisibility.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

nonisolated
public enum ControlVisibility {
    /// Control is always visible.
    case always
    
    /// Control is visible while the mouse hovers.
    case onHover
    
    /// Control is always hidden.
    case never
}

extension ControlVisibility: Equatable { }

extension ControlVisibility: Hashable { }

extension ControlVisibility: CaseIterable { }

extension ControlVisibility: Sendable { }

#endif
