//
//  HighlightingMenuItem.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

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
    @Environment(\.isEnabled) private var isEnabled
    
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
        _isHighlighted = isHighlighted
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
        _isHighlighted = .constant(isHighlighted)
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        itemBody
            .fixedSize(horizontal: false, vertical: true)
            .contentShape(Rectangle()) // ensures that hit test area (mouse hover and clicks) works as expected when this view is wrapped in another view
            .geometryGroupIfSupportedByPlatform()
            .onHover { state in
                guard isEnabled else { setHighlight(state: false); return }
                if isHighlightedInternal != state {
                    setHighlight(state: state)
                }
            }
            .onChange(of: isHighlighted) { newValue in
                isHighlightedInternal = newValue
            }
            .onChange(of: isEnabled) { newValue in
                if !newValue {
                    setHighlight(state: false)
                }
            }
    }
    
    private var itemBody: some View {
        ZStack {
            backgroundShape
                .background(isHighlightedInternal ? visualEffect : nil)
                .foregroundColor(style.backColor(hover: isHighlightedInternal, for: colorScheme) ?? .clear)
                .clipShape(backgroundShape)
                .padding([.leading, .trailing], MenuGeometry.menuHorizontalHighlightInset)
            
            VStack(alignment: .leading) {
                heightBoundContent
                    .foregroundColor(style.textColor(hover: isHighlighted, isEnabled: isEnabled))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .trailing], MenuGeometry.menuHorizontalContentInset)
        }
    }
    
    @ViewBuilder
    private var heightBoundContent: some View {
        switch height {
        case .standardTextOnly, .controlCenterIconItem, .controlCenterSection, .custom(_, _):
            content
                .frame(height: height.boundsHeight)
            
        case let .auto(verticalPadding: isVerticalPadded):
            if isVerticalPadded {
                content
                    .padding([.top, .bottom], height.paddingHeight / 2)
            } else {
                content
            }
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
    
    private func setHighlight(state: Bool) {
        isHighlighted = state
        isHighlightedInternal = state
    }
}

#endif
