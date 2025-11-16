//
//  MenuDisclosureGroupStyle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

nonisolated
public enum MenuDisclosureGroupStyle {
    /// Section style: Expanded content body has no added background (transparent).
    case section
    
    /// Menu item style: Expanded content body has a shaded background.
    case menuItem
}

extension MenuDisclosureGroupStyle: Equatable { }

extension MenuDisclosureGroupStyle: Hashable { }

extension MenuDisclosureGroupStyle: CaseIterable { }

extension MenuDisclosureGroupStyle: Sendable { }

#endif
