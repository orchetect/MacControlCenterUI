//
//  MenuSliderStyle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Control style for ``MenuSlider``.
nonisolated
public enum MenuSliderStyle {
    /// macOS 26 style slider.
    case macOS26
    
    /// macOS 10.15 through 15 style slider.
    case macOS10_15Thru15
}

extension MenuSliderStyle: Equatable { }

extension MenuSliderStyle: Hashable { }

extension MenuSliderStyle: CaseIterable { }

extension MenuSliderStyle: Sendable { }

#endif
