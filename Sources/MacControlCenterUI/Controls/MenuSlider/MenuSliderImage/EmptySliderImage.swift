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
}

// MARK: - Static Constructor

extension MenuSliderImage where Self == EmptySliderImage {
    /// A ``MenuSliderImage`` usable for not displaying an image.
    public static var empty: EmptySliderImage {
        EmptySliderImage()
    }
}


#endif
