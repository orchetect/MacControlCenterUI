//
//  MenuItem.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Generic ``MacControlCenterMenu`` menu entry to contain any arbitrary view.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
internal struct MenuItem<Content: View>: View, MacControlCenterMenuItem {
    public var content: Content
    
    // MARK: Init
    
    public init(
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .padding([.leading, .trailing], menuHorizontalContentInset)
        .padding([.top, .bottom], menuItemPadding)
    }
}
