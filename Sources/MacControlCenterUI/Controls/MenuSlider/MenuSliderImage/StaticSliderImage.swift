//
//  StaticSliderImage.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// A ``MenuSliderImage`` static image.
nonisolated
public struct StaticSliderImage: MenuSliderImage {
    private let img: Image
    
    public init(_ img: Image) {
        self.img = img
    }
    
    public func staticImage(style: MenuSliderStyle) -> MenuSliderImageDescriptor? {
        MenuSliderImageDescriptor(image: img)
    }
}

// MARK: - Static Constructor

extension MenuSliderImage where Self == StaticSliderImage {
    /// A ``MenuSliderImage`` static image.
    public static func `static`(_ image: Image) -> StaticSliderImage {
        StaticSliderImage(image)
    }
    
    /// A ``MenuSliderImage`` static image.
    public static func `static`(systemName: String) -> StaticSliderImage {
        StaticSliderImage(Image(systemName: systemName))
    }
}


#endif
