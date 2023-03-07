//
//  MenuBody.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MenuBarExtraAccess

/// Internal menu body layout.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
internal struct MenuBody: View, MacControlCenterMenuItem {
    // MARK: Public Properties
    
    public var content: [any View]
    
    /// Item context applied to each top-level view in `content`.
    public var itemContext: ((_ item: any View) -> any View)?
    
    // MARK: Init
    
    /// Init with content.
    public init(
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) {
        self.content = content()
    }
    
    /// Init with content.
    /// Item context applied to each top-level view in `content`.
    public init(
        content: [any View],
        itemContext: ((_ item: any View) -> any View)? = nil
    ) {
        self.content = content
        self.itemContext = itemContext
    }
    
    // MARK: Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            unwrapContent
        }
        //.introspectMenuBarExtraWindow { menuBarExtraWindow in
        //
        //}
    }
    
    // MARK: Helpers
    
    private var unwrapContent: some View {
        ForEach(content.indices, id: \.self) {
            convertView(content[$0])
        }
    }
    
    private func convertView(_ view: any View) -> AnyView {
        let viewWithContext = itemContext?(view) ?? view
        
        switch view {
        case is (any MacControlCenterMenuItem):
            return AnyView(viewWithContext)
            
        default:
            let wrappedView = PaddedMenuItem {
                AnyView(viewWithContext)
            }
            return AnyView(wrappedView)
        }
    }
}
