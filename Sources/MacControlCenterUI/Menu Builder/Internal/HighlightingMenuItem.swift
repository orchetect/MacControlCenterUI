//
//  HighlightingMenuItem.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Generic ``MacControlCenterMenu`` menu entry to contain any arbitrary view that highlights the
/// background when the mouse hovers.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
internal struct HighlightingMenuItem<Content: View>: View, MacControlCenterMenuItem {
    // MARK: Public Properties
    
    public var style: MenuCommandStyle = .controlCenter
    public var height: CGFloat
    public var content: Content
    @Binding public var isHighlighted: Bool
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: Private State
    
    @State private var isHighlightedInternal: Bool = false
    
    // MARK: Init
    
    public init(
        style: MenuCommandStyle = .controlCenter,
        height: CGFloat,
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
        height: CGFloat,
        @ViewBuilder _ content: () -> Content
    ) {
        self.style = style
        self.height = height
        self._isHighlighted = .constant(false)
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: .init(width: 5, height: 5))
                .background(isHighlightedInternal ? visualEffect : nil)
                .foregroundColor(style.backColor(hover: isHighlightedInternal) ?? .clear)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 5, height: 5)))
                .padding([.leading, .trailing], MenuGeometry.menuHorizontalHighlightInset)
            
            VStack(alignment: .leading) {
                content
            }
            .padding([.leading, .trailing], MenuGeometry.menuHorizontalContentInset)
        }
        .frame(minHeight: height)
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
    
    private var visualEffect: VisualEffect? {
        if colorScheme == .dark {
            return VisualEffect(
                .underWindowBackground,
                vibrancy: true,
                blendingMode: .withinWindow
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
