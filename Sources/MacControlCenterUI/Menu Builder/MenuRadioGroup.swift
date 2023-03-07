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
public struct MenuRadioGroup<Data: RandomAccessCollection, Content: View>: View,
    MacControlCenterMenuItem
    where Data.Element: Hashable, Data.Element: Identifiable
{
    public let data: Data
    @Binding public var selection: Data.Element.ID?
    public let content: (Data.Element) -> MenuRadioGroupRow<Data, Content>
    
    public init(
        _ data: Data,
        selection: Binding<Data.Element.ID?>,
        content: @escaping (Data.Element) -> MenuRadioGroupRow<Data, Content>
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
                let metadata = content(item)
                HStack {
                    MacControlCenterCircleToggle(
                        isOn: .constant(selection == item.id),
                        style: .menu,
                        invertForeground: metadata.invertForeground,
                        image: metadata.image(item)
                    ) { state in
                        selection = selection == item.id ? nil : item.id
                    }
                    
                    metadata.content(item)
                    Spacer(minLength: 0)
                }
            }
        }
    }
    
    public var contentHeight: CGFloat {
        MacControlCenterCircleButtonStyle.menu.size
            + (MenuGeometry.menuVerticalPadding * 2)
            + MenuGeometry.menuItemPadding
    }
}

/// Row item used in ``MenuRadioGroup``.
public struct MenuRadioGroupRow<Data: RandomAccessCollection, Content: View>
where Data.Element: Hashable, Data.Element: Identifiable
{
    public var image: (Data.Element) -> Image?
    public var content: (Data.Element) -> Content
    public var invertForeground: Bool
    
    public init(
        invertForeground: Bool = false,
        image: @escaping (Data.Element) -> Image?,
        content: @escaping (Data.Element) -> Content
    ) {
        self.invertForeground = invertForeground
        self.image = image
        self.content = content
    }
    
    public init(
        invertForeground: Bool = false,
        image: Image?,
        content: @escaping (Data.Element) -> Content
    ) {
        self.invertForeground = invertForeground
        self.image = { _ in image }
        self.content = content
    }
}
