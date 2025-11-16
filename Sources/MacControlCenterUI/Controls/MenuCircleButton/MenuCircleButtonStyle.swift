//
//  MenuCircleButtonStyle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Style for ``MenuCircleToggle`` and ``MenuCircleButton``.
nonisolated
public struct MenuCircleButtonStyle {
    public var image: Image?
    public var offImage: Image?
    public var offImageDimAmount: CGFloat?
    public var imagePadding: CGFloat
    public var color: Color?
    public var offColor: Color?
    public var invertForeground: Bool
    
    public init(
        image: Image?,
        offImageDimAmount: CGFloat? = nil,
        imagePadding: CGFloat = 0,
        color: Color? = Color(NSColor.controlAccentColor),
        offColor: Color? = Color(NSColor.controlColor),
        invertForeground: Bool = false
    ) {
        self.image = image?.resizable()
        offImage =  image?.resizable()
        self.offImageDimAmount = offImageDimAmount
        self.imagePadding = imagePadding
        self.color = color
        self.offColor = offColor
        self.invertForeground = invertForeground
    }
    
    public init(
        image: Image?,
        offImage: Image?,
        offImageDimAmount: CGFloat? = nil,
        imagePadding: CGFloat = 0,
        color: Color? = Color(NSColor.controlAccentColor),
        offColor: Color? = Color(NSColor.controlColor),
        invertForeground: Bool = false
    ) {
        self.image = image?.resizable()
        self.offImage = offImage?.resizable()
        self.offImageDimAmount = offImageDimAmount
        self.imagePadding = imagePadding
        self.color = color
        self.offColor = offColor
        self.invertForeground = invertForeground
    }
}

extension MenuCircleButtonStyle: Equatable { }

extension MenuCircleButtonStyle: Sendable { }

// MARK: - Static Constructors

extension MenuCircleButtonStyle {
    /// Standard circle button style.
    public static func standard(image: Image) -> Self {
        MenuCircleButtonStyle(
            image: image
        )
    }
    
    /// Standard circle button style.
    public static func standard(systemImage: String) -> Self {
        MenuCircleButtonStyle(
            image: Image(systemName: systemImage)
        )
    }
    
    /// Checkmark button style suitable for options nested under a ``MenuDisclosureGroup``.
    public static func checkmark() -> Self {
        MenuCircleButtonStyle(
            image: Image(systemName: "checkmark"),
            offImage: nil,
            imagePadding: 7,
            color: nil,
            offColor: nil
        )
    }
    
    /// A full-size custom image button style without a circle background.
    public static func icon(_ image: Image) -> Self {
        MenuCircleButtonStyle(
            image: image,
            offImage: image,
            offImageDimAmount: 0.5,
            imagePadding: -1,
            color: nil,
            offColor: nil
        )
    }
}

// MARK: - Convenience Methods

extension MenuCircleButtonStyle {
    public var hasColor: Bool {
        color != nil && color != .clear
    }
    
    public var hasOffColor: Bool {
        offColor != nil && offColor != .clear
    }
    
    public func hasColor(forState state: Bool) -> Bool {
        state ? hasColor : hasOffColor
    }
    
    public func color(forState state: Bool, isEnabled: Bool, colorScheme: ColorScheme) -> Color? {
        let base: Color? = state
            ? color
            : (colorScheme == .dark ? offColor : offColor?.opacity(0.2))
        return isEnabled ? base : base?.opacity(0.4)
    }
    
    public func image(forState state: Bool) -> Image? {
        state ? image : offImage
    }
    
    public func hasImage(forState state: Bool) -> Bool {
        state ? image != nil : offImage != nil
    }
}

#endif
