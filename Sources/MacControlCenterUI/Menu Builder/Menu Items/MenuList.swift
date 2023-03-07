//
//  MenuList.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

/// ``MacControlCenterMenu`` list allowing for a item selection.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuList<Data: RandomAccessCollection, Content: MenuStateItem>: View,
    MacControlCenterMenuItem
    where Data.Element: Hashable, Data.Element: Identifiable,
          Content.Data == Data, Content.Data.Element == Data.Element
{
    public let data: Data
    @Binding public var selection: Data.Element.ID?
    public let content: (Data.Element) -> Content
    
    public init(
        _ data: Data,
        selection: Binding<Data.Element.ID?>,
        content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self._selection = selection
        self.content = content
    }
    
    public var body: some View {
        ForEach(data, id: \.id) { item in
            HighlightingMenuItem(
                style: .controlCenter,
                height: contentHeight
            ) {
                content(item).body(for: item, selection: $selection)
            }
        }
    }
    
    public var contentHeight: CGFloat {
        MacControlCenterCircleButtonStyle.menu.size
            + (MenuGeometry.menuVerticalPadding * 2)
            + MenuGeometry.menuItemPadding
    }
}
