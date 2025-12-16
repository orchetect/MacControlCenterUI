//
//  EmptySliderImage.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// A ``MenuSliderImage`` usable for not displaying an image.
nonisolated
public struct EmptySliderImage: MenuSliderImage {
    public init() { }
    
    public func staticImage() -> Image? {
        nil
    }
    
    public func image(
        for value: CGFloat,
        oldValue: CGFloat?
    ) -> MenuSliderImageUpdate? {
        nil
    }
}

// MARK: - Static Constructor

extension MenuSliderImage where Self == EmptySliderImage {
    /// A ``MenuSliderImage`` usable for not displaying an image.
    public static var empty: EmptySliderImage {
        EmptySliderImage()
    }
}


#endif
