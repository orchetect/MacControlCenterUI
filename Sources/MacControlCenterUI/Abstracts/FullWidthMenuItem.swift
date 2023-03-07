//
//  FullWidthMenuItem.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Generic full-width ``MacControlCenterMenu`` menu item abstract.
/// Utility for when you need to escape the automatic padding that ``MacControlCenterMenu`` applies.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct FullWidthMenuItem<Content: View>: View, MacControlCenterMenuItem {
    public var verticalPadding: Bool
    public var content: Content
    
    // MARK: Init
    
    public init(
        verticalPadding: Bool = true,
        @ViewBuilder _ content: () -> Content
    ) {
        self.verticalPadding = verticalPadding
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .padding(
            [.top, .bottom],
            verticalPadding ? MenuGeometry.menuItemPadding : 0
        )
    }
}
