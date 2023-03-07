//
//  Utilities.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension CGFloat {
    internal func clamped(to range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound { return range.lowerBound }
        if self > range.upperBound { return range.upperBound }
        return self
    }
    
    internal func clamped(to range: PartialRangeFrom<Self>) -> Self {
        if self < range.lowerBound { return range.lowerBound }
        return self
    }
}

// MARK: - Image Utils

class NoInsetHostingView<V>: NSHostingView<V> where V: View {
    override var safeAreaInsets: NSEdgeInsets {
        .init()
    }
}

extension View {
    func renderAsImage() -> NSImage? {
        let view = NoInsetHostingView(rootView: self)
        view.setFrameSize(view.fittingSize)
        return view.bitmapImage()
    }
}

public extension NSView {
    func bitmapImage() -> NSImage? {
        guard let rep = bitmapImageRepForCachingDisplay(in: bounds) else {
            return nil
        }
        cacheDisplay(in: bounds, to: rep)
        guard let cgImage = rep.cgImage else {
            return nil
        }
        return NSImage(cgImage: cgImage, size: bounds.size)
    }
}

extension NSImage {
    /// Fills the image with a solid color.
    convenience init(color: NSColor, size: NSSize) {
        self.init(size: size)
        
        lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        unlockFocus()
    }
    
    /// Draws a oval (or circle if height == width) within the given size's bounds with a solid fill color.
    convenience init(color: NSColor, ovalSize size: NSSize) {
        self.init(size: size)
        
        lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high
        let frame = NSRect(origin: .zero, size: size)
        color.set()
        NSBezierPath(ovalIn: frame).fill()
        draw(at: .zero, from: frame, operation: .copy, fraction: 1)
        unlockFocus()
    }
}

extension NSImage {
    /// Copies this image to a new one with a circular mask.
    convenience init(circleMask size: NSSize) {
        self.init(size: size)
        
        lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high
        let frame = NSRect(origin: .zero, size: size)
        NSColor.black.drawSwatch(in: frame)
        unlockFocus()
        
        lockFocus()
        NSBezierPath(ovalIn: frame).addClip()
        draw(at: .zero, from: frame, operation: .destinationOut, fraction: 1)
        unlockFocus()
    }
}
