//
//  MenuSliderImageDescriptor.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

public struct MenuSliderImageDescriptor {
    public var image: Image
    public var scale: CGFloat? = nil
    public var xOffset: CGFloat? = nil
    
    public init(image: Image, scale: CGFloat? = nil, xOffset: CGFloat? = nil) {
        self.image = image
        self.scale = scale
        self.xOffset = xOffset
    }
}

extension MenuSliderImageDescriptor: Equatable { }

extension MenuSliderImageDescriptor: Sendable { }

#endif
