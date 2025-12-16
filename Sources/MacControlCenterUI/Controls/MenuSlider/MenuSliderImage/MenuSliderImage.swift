//
//  MenuSliderImage.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Protocol to allow types to define ``MenuSlider`` image states.
nonisolated
public protocol MenuSliderImage: Equatable, Sendable {
    /// Return an image if the image is static.
    func staticImage() -> Image?
    
    /// Return an image for minimum value.
    func minImage() -> Image?
    
    /// Return an image for maximum value.
    func maxImage() -> Image?
    
    /// Return an image conditionally based on slider value.
    func image(for value: CGFloat, oldValue: CGFloat?, force: Bool) -> MenuSliderImageUpdate?
    
    /// Transform the image.
    func transform(image: Image, for value: CGFloat) -> AnyView?
}

// MARK: - Default implementation

extension MenuSliderImage {
    public func staticImage() -> Image? {
        nil
    }
    
    public func minImage() -> Image? {
        guard let result = image(for: 0.0, oldValue: nil, force: true) else { return nil }
        
        switch result {
        case let .newImage(image): return image
        case .noChange: return nil
        }
    }
    
    public func maxImage() -> Image? {
        guard let result = image(for: 1.0, oldValue: nil, force: true) else { return nil }
        
        switch result {
        case let .newImage(image): return image
        case .noChange: return nil
        }
    }
    
    public func image(
        for value: CGFloat,
        oldValue: CGFloat?,
        force: Bool
    ) -> MenuSliderImageUpdate? {
        nil
    }
    
    public func transform(image: Image, for value: CGFloat) -> AnyView? {
        nil
    }
}

// MARK: - Methods

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

#endif
