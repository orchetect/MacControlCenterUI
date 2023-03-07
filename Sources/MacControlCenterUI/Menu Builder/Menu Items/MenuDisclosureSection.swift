//
//  MenuDisclosureSection.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// ``MacControlCenterMenu`` disclosure group menu item with section label.
/// Used to hide or show optional content in a menu, but using a section as the button.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuDisclosureSection<Label: View>: View, MacControlCenterMenuItem {
    public var label: Label
    public var divider: Bool
    @Binding public var isExpanded: Bool
    public var content: () -> [any View]
    
    @State private var isHighlighted = false
    
    // MARK: Init
    
    public init<S>(
        _ label: S,
        divider: Bool = true,
        isExpanded: Binding<Bool>,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where S: StringProtocol, Label == MenuSectionText {
        self.label = MenuSectionText(text: Text(label))
        self.divider = divider
        self._isExpanded = isExpanded
        self.content = content
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        divider: Bool = true,
        isExpanded: Binding<Bool>,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where Label == MenuSectionText {
        self.label = MenuSectionText(text: Text(titleKey))
        self.divider = divider
        self._isExpanded = isExpanded
        self.content = content
    }
    
    public init(
        divider: Bool = true,
        isExpanded: Binding<Bool>,
        @ViewBuilder _ label: () -> Label,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) {
        self.divider = divider
        self._isExpanded = isExpanded
        self.label = label()
        self.content = content
    }
    
    // MARK: Body
    
    public var body: some View {
        if divider {
            MenuBody {
                Divider()
            }
        }
        
        MenuDisclosureGroup(
            isExpanded: $isExpanded,
            labelHeight: 20,
            label: { label },
            content: content
        )
    }
}
