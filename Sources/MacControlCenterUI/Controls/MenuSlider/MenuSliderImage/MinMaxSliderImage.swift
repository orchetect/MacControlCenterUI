//
//  MinMaxSliderImage.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// A ``MenuSliderImage`` static minimum & maximum value image set.
nonisolated
public struct MinMaxSliderImage {
    private var minImg: Image
    private var maxImg: Image
    
    public init(min: Image, max: Image) {
        minImg = min
        maxImg = max
    }
}

extension MinMaxSliderImage: MenuSliderImage {
    public func staticImage(style: MenuSliderStyle) -> MenuSliderImageDescriptor? {
        nil
    }
    
    public func minImage(style: MenuSliderStyle) -> MenuSliderImageDescriptor? {
        MenuSliderImageDescriptor(image: minImg)
    }
    
    public func maxImage(style: MenuSliderStyle) -> MenuSliderImageDescriptor? {
        MenuSliderImageDescriptor(image: maxImg)
    }
    
    public func deltaImage(forValue value: CGFloat, oldValue: CGFloat?, style: MenuSliderStyle, force: Bool) -> MenuSliderImageUpdate? {
        if isNewlyEntered(value: value, oldValue: oldValue, in: 0.0 ... 0.4999, force: force) {
            return .newImage(MenuSliderImageDescriptor(image: minImg))
        }
        
        if isNewlyEntered(value: value, oldValue: oldValue, in: 0.5 ... 1.0, force: force) {
            return .newImage(MenuSliderImageDescriptor(image: maxImg))
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
