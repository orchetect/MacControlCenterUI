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
    func staticImage(style: MenuSliderStyle) -> MenuSliderImageDescriptor?
    
    /// Return an image based on slider value.
    func image(forValue value: CGFloat, style: MenuSliderStyle) -> MenuSliderImageDescriptor?
    
    /// Return an image conditionally based on slider value.
    func deltaImage(forValue value: CGFloat, oldValue: CGFloat?, style: MenuSliderStyle, force: Bool) -> MenuSliderImageUpdate?
}

// MARK: - Default implementation

extension MenuSliderImage {
    public func staticImage(style: MenuSliderStyle) -> MenuSliderImageDescriptor? {
        nil
    }
    
    public func image(forValue value: CGFloat, style: MenuSliderStyle) -> MenuSliderImageDescriptor? {
        nil
    }
    
    public func deltaImage(forValue value: CGFloat, oldValue: CGFloat?, style: MenuSliderStyle, force: Bool) -> MenuSliderImageUpdate? {
        nil
    }
}

// MARK: - Public Methods

extension MenuSliderImage {
    /// Return an image for minimum value (`0.0`).
    public func minImage(style: MenuSliderStyle) -> MenuSliderImageDescriptor? {
        image(forValue: 0.0, style: style)
    }
    
    /// Return an image for maximum value (`1.0`).
    public func maxImage(style: MenuSliderStyle) -> MenuSliderImageDescriptor? {
        image(forValue: 1.0, style: style)
    }
    
    /// Convenience method to test if a value has newly entered a given value range.
    public func isNewlyEntered(
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
