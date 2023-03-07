//
//  MenuStateItem.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

public protocol MenuStateItem where Data.Element: Hashable, Data.Element: Identifiable {
    associatedtype Data: RandomAccessCollection
    associatedtype Content: View
    var invertForeground: Bool { get set }
    var image: (_ item: Data.Element) -> Image? { get }
    var content: (_ item: Data.Element) -> Content { get }
    func body(for time: Data.Element, selection: Binding<Data.Element.ID?>) -> AnyView
}

/// Standard native macOS Control Center circle toggle menu item.
public struct CircleToggleMenuStateItem<Data: RandomAccessCollection, Content: View>: MenuStateItem
where Data.Element: Hashable, Data.Element: Identifiable
{
    public var invertForeground: Bool
    public var image: (_ item: Data.Element) -> Image?
    public var content: (_ item: Data.Element) -> Content
    
    public init(
        invertForeground: Bool = false,
        image: @escaping (_ item: Data.Element) -> Image?,
        @ViewBuilder content: @escaping (_ item: Data.Element) -> Content
    ) {
        self.invertForeground = invertForeground
        self.image = image
        self.content = content
    }
    
    public init(
        invertForeground: Bool = false,
        image: Image?,
        content: @escaping (_ item: Data.Element) -> Content
    ) {
        self.invertForeground = invertForeground
        self.image = { _ in image }
        self.content = content
    }
    
    public func body(
        for item: Data.Element,
        selection: Binding<Data.Element.ID?>
    ) -> AnyView {
        AnyView(
            HStack {
                MacControlCenterCircleToggle(
                    isOn: .constant(selection.wrappedValue == item.id),
                    style: .menu,
                    invertForeground: invertForeground,
                    image: image(item)
                ) { state in
                    selection.wrappedValue = selection.wrappedValue == item.id ? nil : item.id
                }
                
                content(item)
                Spacer(minLength: 0)
            }
        )
    }
}

/// Custom style. Define your own view without using the circle toggle.
public struct CustomMenuStateItem<Data: RandomAccessCollection, Content: View>: MenuStateItem
where Data.Element: Hashable, Data.Element: Identifiable
{
    public var invertForeground: Bool = false
    public var image: (_ item: Data.Element) -> Image? = { _ in nil }
    public var content: (_ item: Data.Element) -> Content
    
    public init(
        @ViewBuilder _ content: @escaping (_ item: Data.Element) -> Content
    ) {
        self.content = content
    }
    
    public func body(
        for item: Data.Element,
        selection: Binding<Data.Element.ID?>
    ) -> AnyView {
        AnyView(content(item))
    }
}
