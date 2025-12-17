//
//  MenuList.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import SwiftUI

/// ``MacControlCenterMenu`` menu item list allowing for item selection.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuList<Data: RandomAccessCollection, Content: View>: View,
    MacControlCenterMenuItem
    where Data.Element: Hashable, Data.Element: Identifiable
{
    public let data: Data
    @Binding public var selection: Data.Element.ID?
    public let content: (
        _ item: Data.Element,
        _ isSelected: Bool,
        _ itemClicked: @escaping () -> Void
    ) -> Content
    
    /// List.
    public init(
        _ data: Data,
        content: @escaping (_ item: Data.Element) -> Content
    ) {
        self.data = data
        _selection = .constant(nil)
        self.content = { item, _, _ in content(item) }
    }
    
    /// List with single item selection.
    public init(
        _ data: Data,
        selection: Binding<Data.Element.ID?>,
        content: @escaping (_ item: Data.Element) -> Content
    ) where Content: MenuListStateItem {
        self.data = data
        _selection = selection
        self.content = { item, isSelected, itemClicked in
            var c = content(item)
            c.setState(state: isSelected)
            c.setItemClicked(itemClicked)
            return c
        }
    }
    
    /// List with single item selection.
    @_disfavoredOverload
    public init(
        _ data: Data,
        selection: Binding<Data.Element.ID?>,
        @ViewBuilder content: @escaping (
            _ item: Data.Element,
            _ isSelected: Bool,
            _ itemClicked: @escaping () -> Void
        ) -> Content
    ) {
        self.data = data
        _selection = selection
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(data, id: \.id) { item in
                content(item, selection == item.id) { itemClicked(id: item.id) }
            }
        }
        .geometryGroupIfSupportedByPlatform()
    }
    
    private func itemClicked(id: Data.Element.ID) {
        if selection == id { selection = nil; return }
        selection = id
    }
}

#endif
