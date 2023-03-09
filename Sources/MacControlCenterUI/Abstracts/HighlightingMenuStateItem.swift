//
//  HighlightingMenuStateItem.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Generic ``MacControlCenterMenu`` menu item abstract that highlights the background when the
/// mouse hovers and toggles state when clicked.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct HighlightingMenuStateItem<Content: View>: View, MacControlCenterMenuItem {
    public var style: MenuCommandStyle
    public var height: MenuItemSize
    @Binding public var isOn: Bool
    @Binding public var isPressed: Bool
    public let content: () -> Content
    public var onChangeBlock: (_ state: Bool) -> Void
    @Binding public var isHighlighted: Bool
    
    @State public var isHighlightedInternal: Bool = false
    
    public init(
        style: MenuCommandStyle = .controlCenter,
        height: MenuItemSize,
        isOn: Binding<Bool>,
        isPressed: Binding<Bool>,
        @ViewBuilder _ content: @escaping () -> Content,
        onChange onChangeBlock: @escaping (_ state: Bool) -> Void = { _ in }
    ) {
        self.style = style
        self.height = height
        self._isOn = isOn
        self._isPressed = isPressed
        self.content = content
        self.onChangeBlock = onChangeBlock
        self._isHighlighted = .constant(false)
    }
    
    public init(
        style: MenuCommandStyle = .controlCenter,
        height: MenuItemSize,
        isOn: Binding<Bool>,
        isHighlighted: Binding<Bool>,
        isPressed: Binding<Bool>,
        @ViewBuilder _ content: @escaping () -> Content,
        onChange onChangeBlock: @escaping (_ state: Bool) -> Void = { _ in }
    ) {
        self.style = style
        self.height = height
        self._isOn = isOn
        self._isHighlighted = isHighlighted
        self._isPressed = isPressed
        self.content = content
        self.onChangeBlock = onChangeBlock
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HighlightingMenuItem(
                style: style,
                height: height,
                isHighlighted: $isHighlightedInternal
            ) {
                content()
            }
            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let hit = geometry.frame(in: .local).contains(value.location)
                        isPressed = hit
                    }
                    .onEnded { value in
                        defer { isPressed = false }
                        if isPressed {
                            isOn.toggle()
                            onChangeBlock(isOn)
                        }
                    }
            )
        }
        .frame(height: height.boundsHeight)
        
        .onChange(of: isHighlighted) { newValue in
            isHighlightedInternal = newValue
        }
        .onChange(of: isHighlightedInternal) { newValue in
            isHighlighted = newValue
        }
    }
}
