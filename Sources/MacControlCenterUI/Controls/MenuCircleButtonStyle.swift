//
//  MenuCircleButtonStyle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Style for ``MenuCircleToggle`` and ``MenuCircleButton``.
public struct MenuCircleButtonStyle {
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

extension MenuCircleButtonStyle {
    public var hasColor: Bool {
        if color == nil || color == .clear { return false }
        return true
    }
    
    public func color(forState: Bool, colorScheme: ColorScheme) -> Color? {
        forState
        ? color
        : colorScheme == .dark ? offColor : offColor?.opacity(0.2)
    }
    
    public func image(forState: Bool) -> Image? {
        forState ? image : offImage
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
}
