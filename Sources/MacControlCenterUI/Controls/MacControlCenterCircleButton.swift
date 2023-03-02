//
//  MacControlCenterCircleButton.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MacControlCenterCircleButton<Label: View>: View {
    // MARK: Public Properties
    
    public var image: Image
    public var color: Color
    public var invertForeground: Bool
    public var label: Label?
    public var actionBlock: () -> Void
    
    // MARK: Private State
    
    @State private var isMouseDown: Bool = false
    private var style: MacControlCenterCircleButtonStyle
    
    // MARK: Init
    
    public init(
        style: MacControlCenterCircleButtonStyle = .menu,
        color: Color = Color(NSColor.controlAccentColor),
        invertForeground: Bool = false,
        image: Image,
        action actionBlock: @escaping () -> Void
    ) where Label == EmptyView {
        self.style = style
        self.color = color
        self.invertForeground = invertForeground
        self.image = image
        self.label = nil
        self.actionBlock = actionBlock
    }
    
    public init<S>(
        _ title: S,
        style: MacControlCenterCircleButtonStyle = .menu,
        color: Color = Color(NSColor.controlAccentColor),
        invertForeground: Bool = false,
        image: Image,
        @ViewBuilder label: @escaping () -> Label,
        action actionBlock: @escaping () -> Void
    ) where S: StringProtocol, Label == Text {
        self.init(
            style: style,
            color: color,
            invertForeground: invertForeground,
            image: image,
            label: { Text(title) },
            action: actionBlock
        )
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        style: MacControlCenterCircleButtonStyle = .menu,
        color: Color = Color(NSColor.controlAccentColor),
        invertForeground: Bool = false,
        image: Image,
        action actionBlock: @escaping () -> Void
    ) where Label == Text {
        self.init(
            style: style,
            color: color,
            invertForeground: invertForeground,
            image: image,
            label: { Text(titleKey) },
            action: actionBlock
        )
    }
    
    public init(
        style: MacControlCenterCircleButtonStyle = .menu,
        color: Color = Color(NSColor.controlAccentColor),
        invertForeground: Bool = false,
        image: Image,
        @ViewBuilder label: @escaping () -> Label,
        action actionBlock: @escaping () -> Void
    ) {
        self.style = style
        self.color = color
        self.invertForeground = invertForeground
        self.image = image
        self.label = label()
        self.actionBlock = actionBlock
    }
    
    // MARK: Body
    
    public var body: some View {
        MacControlCenterCircleToggle(
            isOn: .constant(false),
            style: style,
            color: color,
            invertForeground: invertForeground,
            image: image,
            label: label
        ) { _ in
            actionBlock()
        }
    }
}
