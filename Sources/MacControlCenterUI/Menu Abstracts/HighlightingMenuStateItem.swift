//
//  HighlightingMenuStateItem.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Generic ``MacControlCenterMenu`` menu item abstract that highlights the background when the
/// mouse hovers and toggles state when clicked.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct HighlightingMenuStateItem<Content: View>: View, MacControlCenterMenuItem {
    // MARK: Public Properties
    
    public var style: MenuCommandStyle
    public var height: MenuItemSize
    @Binding public var isOn: Bool
    @Binding public var isPressed: Bool
    @Binding public var isHighlighted: Bool
    public let content: () -> Content
    public var onChangeBlock: (_ state: Bool) -> Void
    
    // MARK: Environment
    
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: Private State
    
    @State private var isHighlightedInternal: Bool = false
    
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
        _isOn = isOn
        _isPressed = isPressed
        self.content = content
        self.onChangeBlock = onChangeBlock
        _isHighlighted = .constant(false)
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
        _isOn = isOn
        _isHighlighted = isHighlighted
        _isPressed = isPressed
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
                        guard isEnabled else { return }
                        let hit = geometry.frame(in: .local).contains(value.location)
                        isPressed = hit
                    }
                    .onEnded { value in
                        guard isEnabled else { return }
                        defer { isPressed = false }
                        if isPressed {
                            isOn.toggle()
                            onChangeBlock(isOn)
                        }
                    }
            )
            .onChange(of: isEnabled) { newValue in
                if !isEnabled {
                    isPressed = false
                }
            }
        }
        .frame(height: height.boundsHeight)
        .geometryGroupIfSupportedByPlatform()
        
        .onChange(of: isHighlighted) { newValue in
            isHighlightedInternal = newValue
        }
        .onChange(of: isHighlightedInternal) { newValue in
            isHighlighted = newValue
        }
    }
}

#endif
