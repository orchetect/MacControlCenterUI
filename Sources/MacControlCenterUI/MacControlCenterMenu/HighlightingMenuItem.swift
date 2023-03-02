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
    public var style: MenuCommandStyle = .controlCenter
    public var height: CGFloat
    public var content: Content
    @Binding public var isHighlighted: Bool
    
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
    
    // MARK: Body
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: .init(width: 5, height: 5))
                .fill(style.backColor(hover: isHighlighted) ?? .clear)
                .padding([.leading, .trailing], MenuGeometry.menuHorizontalHighlightInset)
            
            VStack(alignment: .leading) {
                content
            }
            .padding([.leading, .trailing], MenuGeometry.menuHorizontalContentInset)
        }
        .frame(minHeight: height)
        .onHover { state in
            if isHighlighted != state {
                isHighlighted = state
            }
        }
    }
}
