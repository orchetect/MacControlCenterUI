//
//  MenuCircleButtonStyle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Style for ``MenuCircleToggle`` and ``MenuCircleButton``.
public struct MenuCircleButtonStyle {
    public var image: Image?
    public var offImage: Image?
    public var dimOffImage: Bool
    public var imagePadding: CGFloat
    public var color: Color?
    public var offColor: Color?
    public var invertForeground: Bool
    
    public init(
        image: Image?,
        dimOffImage: Bool = false,
        imagePadding: CGFloat = 0,
        color: Color? = Color(NSColor.controlAccentColor),
        offColor: Color? = Color(NSColor.controlColor),
        invertForeground: Bool = false
    ) {
        self.image = image?.resizable()
        self.dimOffImage = dimOffImage
        self.imagePadding = imagePadding
        self.offImage =  image
        self.color = color
        self.offColor = offColor
        self.invertForeground = invertForeground
    }
    
    public init(
        image: Image?,
        offImage: Image?,
        dimOffImage: Bool = false,
        imagePadding: CGFloat = 0,
        color: Color? = Color(NSColor.controlAccentColor),
        offColor: Color? = Color(NSColor.controlColor),
        invertForeground: Bool = false
    ) {
        self.image = image?.resizable()
        self.offImage = offImage?.resizable()
        self.dimOffImage = dimOffImage
        self.imagePadding = imagePadding
        self.color = color
        self.offColor = offColor
        self.invertForeground = invertForeground
    }
}

// MARK: - Convenience Methods

extension MenuCircleButtonStyle {
    public var hasColor: Bool {
        if color == nil || color == .clear { return false }
        return true
    }
    
    public func color(forState state: Bool, isEnabled: Bool, colorScheme: ColorScheme) -> Color? {
        let base: Color? = state
            ? color
            : colorScheme == .dark ? offColor : offColor?.opacity(0.2)
        return isEnabled ? base : base?.opacity(0.4)
    }
    
    public func image(forState state: Bool) -> Image? {
        state ? image : offImage
    }
    
    public func hasImage(forState state: Bool) -> Bool {
        state ? image != nil : offImage != nil
    }
}

// MARK: - Static Constructors

extension MenuCircleButtonStyle {
    public static func standard(image: Image) -> Self {
        MenuCircleButtonStyle(
            image: image
        )
    }
    
    public static func standard(systemImage: String) -> Self {
        MenuCircleButtonStyle(
            image: Image(systemName: systemImage)
        )
    }
    
    public static func checkmark() -> Self {
        MenuCircleButtonStyle(
            image: Image(systemName: "checkmark"),
            offImage: nil,
            imagePadding: 2,
            color: nil,
            offColor: nil
        )
    }
    
    public static func icon(_ image: Image) -> Self {
        MenuCircleButtonStyle(
            image: image,
            offImage: image,
            dimOffImage: true,
            imagePadding: 0,
            color: nil,
            offColor: nil
        )
    }
}

#endif
