//
//  MacControlCenterMenuBuilder.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Menu result builder used in ``MacControlCenterMenu``.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@resultBuilder
public enum MacControlCenterMenuBuilder {
    public static func buildBlock(_ components: (any View)...) -> [any View] {
        components
    }
    
    public static func buildEither(first component: [any View]) -> [any View] {
        component
    }
    
    public static func buildEither(second component: [any View]) -> [any View] {
        component
    }
    
    public static func buildOptional(_ component: [any View]?) -> [any View] {
        component ?? []
    }
    
    public static func buildBlock(_ components: [any View]...) -> [any View] {
        components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: any View) -> [any View] {
        [expression]
    }
    
    public static func buildExpression(_ expression: Void) -> [any View] {
        [any View]()
    }
}

#endif
