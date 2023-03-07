//
//  HighlightingMenuItem.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Generic ``MacControlCenterMenu`` menu item abstract that highlights the background when the
/// mouse hovers.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct HighlightingMenuItem<Content: View>: View, MacControlCenterMenuItem {
    // MARK: Public Properties
    
    public var style: MenuCommandStyle
    public var height: MenuItemSize
    public var content: Content
    @Binding public var isHighlighted: Bool
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: Private State
    
    @State private var isHighlightedInternal: Bool = false
    
    // MARK: Init
    
    public init(
        style: MenuCommandStyle = .controlCenter,
        height: MenuItemSize,
        isHighlighted: Binding<Bool>,
        @ViewBuilder _ content: () -> Content
    ) {
        self.style = style
        self.height = height
        self._isHighlighted = isHighlighted
        self.content = content()
    }
    
    public init(
        style: MenuCommandStyle = .controlCenter,
        height: MenuItemSize,
        isHighlighted: Bool = false,
        @ViewBuilder _ content: () -> Content
    ) {
        self.style = style
        self.height = height
        self._isHighlighted = .constant(isHighlighted)
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        ZStack {
            backgroundShape
                .background(isHighlightedInternal ? visualEffect : nil)
                .foregroundColor(style.backColor(hover: isHighlightedInternal, for: colorScheme) ?? .clear)
                .clipShape(backgroundShape)
                .padding([.leading, .trailing], MenuGeometry.menuHorizontalHighlightInset)
            
            VStack(alignment: .leading) {
                content
            }
            .padding([.leading, .trailing], MenuGeometry.menuHorizontalContentInset)
        }
        .frame(height: height.boundsHeight)
        .onHover { state in
            if isHighlightedInternal != state {
                isHighlightedInternal = state
                isHighlighted = state
            }
        }
        .onChange(of: isHighlighted) { newValue in
            isHighlightedInternal = newValue
        }
    }
    
    // MARK: Helpers
    
    private var backgroundShape: some Shape {
        RoundedRectangle(cornerSize: .init(width: 5, height: 5))
    }
    
    private var visualEffect: VisualEffect? {
        if colorScheme == .dark {
            return VisualEffect(
                .underWindowBackground,
                vibrancy: true,
                blendingMode: .behindWindow
            )
        } else {
            return VisualEffect(
                .underWindowBackground,
                vibrancy: true,
                blendingMode: .behindWindow
            )
        }
    }
}
