//
//  MenuSliderImage.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

public protocol MenuSliderImage {
    /// Return an image if the image is static.
    func staticImage() -> Image?
    
    /// Return an image conditionally based on slider value.
    func image(for value: CGFloat, oldValue: CGFloat?, force: Bool)
        -> MenuSliderImageUpdate?
    
    /// Transform the image.
    func transform(image: Image, for value: CGFloat) -> AnyView?
}

extension MenuSliderImage {
    // Default implementation.
    public func staticImage() -> Image? {
        nil
    }
    
    // Default implementation.
    public func image(
        for value: CGFloat,
        oldValue: CGFloat?,
        force: Bool
    ) -> MenuSliderImageUpdate? {
        nil
    }
    
    // Default implementation.
    public func transform(image: Image, for value: CGFloat) -> AnyView? {
        nil
    }
}

extension MenuSliderImage {
    /// Convenience method to test if a value has newly entered a given value range.
    public func newlyEntered(
        value: CGFloat,
        oldValue: CGFloat?,
        in range: ClosedRange<CGFloat>,
        force: Bool = false
    ) -> Bool {
        if force { return range.contains(value) }
        guard let oldValue = oldValue else { return range.contains(value) }
        return range.contains(value) && !range.contains(oldValue)
    }
}

// MARK: Types

/// Type returned by ``MenuSliderImageProtocol/image(for:oldValue:force:)-3y6w9``.
public enum MenuSliderImageUpdate {
    case noChange
    case newImage(Image)
}
