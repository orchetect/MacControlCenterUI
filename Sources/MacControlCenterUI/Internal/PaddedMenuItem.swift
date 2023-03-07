//
//  PaddedMenuItem.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Generic ``MacControlCenterMenu`` menu entry to contain any arbitrary view.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
internal struct PaddedMenuItem<Content: View>: View, MacControlCenterMenuItem {
    public var verticalPadding: Bool
    public var horizontalPadding: Bool
    public var content: Content
    
    // MARK: Init
    
    public init(
        verticalPadding: Bool = true,
        horizontalPadding: Bool = true,
        @ViewBuilder _ content: () -> Content
    ) {
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .padding([.leading, .trailing],
                 horizontalPadding ? MenuGeometry.menuHorizontalContentInset : 0)
        .padding([.top, .bottom],
                 verticalPadding ? MenuGeometry.menuItemPadding : 0)
    }
}
