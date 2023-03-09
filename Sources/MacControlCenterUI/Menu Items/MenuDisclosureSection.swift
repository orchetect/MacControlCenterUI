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
    
    /// If non-nil, do not use binding.
    internal var nonBindingInitiallyExpanded: Bool? = nil
    
    @State private var isHighlighted = false
    
    // MARK: Init - With Binding
    
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
    
    // MARK: Init - Without Binding
    
    public init<S>(
        _ label: S,
        divider: Bool = true,
        initiallyExpanded: Bool = true,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where S: StringProtocol, Label == MenuSectionText {
        self.label = MenuSectionText(text: Text(label))
        self.divider = divider
        self._isExpanded = .constant(false) // not used
        self.nonBindingInitiallyExpanded = initiallyExpanded
        self.content = content
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        divider: Bool = true,
        initiallyExpanded: Bool = true,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where Label == MenuSectionText {
        self.label = MenuSectionText(text: Text(titleKey))
        self.divider = divider
        self._isExpanded = .constant(false) // not used
        self.nonBindingInitiallyExpanded = initiallyExpanded
        self.content = content
    }
    
    public init(
        divider: Bool = true,
        initiallyExpanded: Bool = true,
        @ViewBuilder _ label: () -> Label,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) {
        self.divider = divider
        self._isExpanded = .constant(false) // not used
        self.nonBindingInitiallyExpanded = initiallyExpanded
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
        
        if let nonBindingInitiallyExpanded {
            MenuDisclosureGroup(
                style: .section,
                initiallyExpanded: nonBindingInitiallyExpanded,
                labelHeight: .controlCenterSection,
                fullLabelToggle: true,
                toggleVisibility: .always,
                label: { label },
                content: content
            )
        } else {
            MenuDisclosureGroup(
                style: .section,
                isExpanded: $isExpanded,
                labelHeight: .controlCenterSection,
                fullLabelToggle: true,
                toggleVisibility: .always,
                label: { label },
                content: content
            )
        }
    }
}
