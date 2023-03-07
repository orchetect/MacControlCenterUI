//
//  MacControlCenterCircleButtonStyle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Style for ``MacControlCenterCircleToggle`` and ``MacControlCenterCircleButton``.
public struct MacControlCenterCircleButtonStyle {
    public var image: Image?
    public var offImage: Image?
    public var imagePadding: CGFloat
    public var color: Color?
    public var offColor: Color?
    public var invertForeground: Bool
    
    public init(
        image: Image?,
        imagePadding: CGFloat = 0,
        color: Color? = Color(NSColor.controlAccentColor),
        offColor: Color? = Color(NSColor.controlColor),
        invertForeground: Bool = false
    ) {
        self.image = image
        self.imagePadding = imagePadding
        self.offImage =  image
        self.color = color
        self.offColor = offColor
        self.invertForeground = invertForeground
    }
    
    public init(
        image: Image?,
        offImage: Image?,
        imagePadding: CGFloat = 0,
        color: Color? = Color(NSColor.controlAccentColor),
        offColor: Color? = Color(NSColor.controlColor),
        invertForeground: Bool = false
    ) {
        self.image = image
        self.offImage = offImage
        self.imagePadding = imagePadding
        self.color = color
        self.offColor = offColor
        self.invertForeground = invertForeground
    }
}

// MARK: - Convenience Methods

extension MacControlCenterCircleButtonStyle {
    public var hasColor: Bool {
        if color == nil || color == .clear { return false }
        return true
    }
    
    public func color(forState: Bool) -> Color? {
        forState ? color : offColor
    }
    
    public func image(forState: Bool) -> Image? {
        forState ? image : offImage
    }
}

// MARK: - Static Constructors

extension MacControlCenterCircleButtonStyle {
    public static func standard(image: Image) -> Self {
        MacControlCenterCircleButtonStyle(
            image: image
        )
    }
    
    public static func standard(systemImage: String) -> Self {
        MacControlCenterCircleButtonStyle(
            image: Image(systemName: systemImage)
        )
    }
    
    public static func checkmark() -> Self {
        MacControlCenterCircleButtonStyle(
            image: Image(systemName: "checkmark"),
            offImage: nil,
            imagePadding: 2,
            color: nil,
            offColor: nil
        )
    }
}
