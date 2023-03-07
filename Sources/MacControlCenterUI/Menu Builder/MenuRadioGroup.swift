//
//  MenuRadioGroup.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

/// ``MacControlCenterMenu`` radio group.
/// Use ``MenuRadioGroupRow`` to define row content and metadata.
///
/// Menu hover colorization can be set using the ``menuCommandStyle(_:)`` view modifier:
///  `menu` style (highlight color) or `commandCenter` style (translucent gray).
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuRadioGroup<Data: RandomAccessCollection, Content: MenuRadioGroupRow>: View,
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
                content(item).rowBody(for: item, selection: $selection)
            }
        }
    }
    
    public var contentHeight: CGFloat {
        MacControlCenterCircleButtonStyle.menu.size
            + (MenuGeometry.menuVerticalPadding * 2)
            + MenuGeometry.menuItemPadding
    }
}

public protocol MenuRadioGroupRow where Data.Element: Hashable, Data.Element: Identifiable {
    associatedtype Data: RandomAccessCollection
    associatedtype Content: View
    var invertForeground: Bool { get set }
    var image: (_ item: Data.Element) -> Image? { get }
    var content: (_ item: Data.Element) -> Content { get }
    func rowBody(for time: Data.Element, selection: Binding<Data.Element.ID?>) -> AnyView
}

//extension MenuRadioGroupRow {
//    /// Standard native macOS Control Center circle toggle style.
//    public static func circleToggle(_ style: MenuRadioGroupCircleToggleRow) -> Self {
//        style
//    }
//
//    /// Custom style. Define your own view without using the circle toggle.
//    public static func custom(_ style: MenuRadioGroupCustomRow) -> Self {
//        style
//    }
//}

/// Standard native macOS Control Center circle toggle style.
public struct MenuRadioGroupCircleToggleRow<Data: RandomAccessCollection, Content: View>: MenuRadioGroupRow
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
    
    public func rowBody(
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
public struct MenuRadioGroupCustomRow<Data: RandomAccessCollection, Content: View>: MenuRadioGroupRow
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
    
    public func rowBody(
        for item: Data.Element,
        selection: Binding<Data.Element.ID?>
    ) -> AnyView {
        AnyView(content(item))
    }
}
