//
//  MenuBody.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import MenuBarExtraAccess
import SwiftUI

/// Useful to add menu body padding imperatively within a view that conforms to
/// ``MacControlCenterMenuItem``.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuBody: View, MacControlCenterMenuItem {
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
    }
    
    // MARK: Helpers
    
    private var unwrapContent: some View {
        let capturedContent = content // prevent index out-of-bounds crashes if content changes while rendering?
        return ForEach(capturedContent.indices, id: \.self) {
            convertView(capturedContent[$0])
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

#endif
