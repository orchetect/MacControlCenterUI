//
//  MinMaxSliderImage.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// A ``MenuSliderImage`` static minimum & maximum value image set.
nonisolated
public struct MinMaxSliderImage: MenuSliderImage {
    private let minImg: Image
    private let maxImg: Image
    
    public init(min: Image, max: Image) {
        minImg = min
        maxImg = max
    }
    
    public func staticImage() -> Image? {
        nil
    }
    
    public func minImage() -> Image? {
        minImg
    }
    
    public func maxImage() -> Image? {
        maxImg
    }
    
    public func image(
        for value: CGFloat,
        oldValue: CGFloat?,
        force: Bool = false
    ) -> MenuSliderImageUpdate? {
        if newlyEntered(value: value, oldValue: oldValue, in: 0.0 ... 0.4999, force: force) {
            return .newImage(minImg)
        }
        
        if newlyEntered(value: value, oldValue: oldValue, in: 0.5 ... 1.0, force: force) {
            return .newImage(maxImg)
        }
        
        return .noChange
    }
}

// MARK: - Static Constructor

extension MenuSliderImage where Self == MinMaxSliderImage {
    /// A ``MenuSliderImage`` static minimum & maximum value image set.
    public static func minMax(min: Image, max: Image) -> MinMaxSliderImage {
        MinMaxSliderImage(min: min, max: max)
    }
    
    /// A ``MenuSliderImage`` static minimum & maximum value image set.
    public static func minMax(minSystemName: String, maxSystemName: String) -> MinMaxSliderImage {
        MinMaxSliderImage(min: Image(systemName: minSystemName), max: Image(systemName: maxSystemName))
    }
}


#endif
