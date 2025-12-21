//
//  MenuDisclosureSection.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

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
    var nonBindingInitiallyExpanded: Bool? = nil
    
    @State private var isHighlighted = false
    
    // MARK: Init - With Binding
    
    @_disfavoredOverload
    public init<S>(
        _ label: S,
        divider: Bool = true,
        isExpanded: Binding<Bool>,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where S: StringProtocol, Label == MenuSectionText<Text> {
        self.label = MenuSectionText(label)
        self.divider = divider
        _isExpanded = isExpanded
        self.content = content
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        divider: Bool = true,
        isExpanded: Binding<Bool>,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where Label == MenuSectionText<Text> {
        label = MenuSectionText(titleKey)
        self.divider = divider
        _isExpanded = isExpanded
        self.content = content
    }
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource,
        divider: Bool = true,
        isExpanded: Binding<Bool>,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where Label == MenuSectionText<Text> {
        label = MenuSectionText(titleResource)
        self.divider = divider
        _isExpanded = isExpanded
        self.content = content
    }
    
    public init<LabelContent: View>(
        divider: Bool = true,
        isExpanded: Binding<Bool>,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View],
        @ViewBuilder label: () -> LabelContent
    ) where Label == MenuSectionText<LabelContent> {
        self.divider = divider
        _isExpanded = isExpanded
        self.label = MenuSectionText(label())
        self.content = content
    }
    
    // MARK: Init - Without Binding
    
    @_disfavoredOverload
    public init<S>(
        _ label: S,
        divider: Bool = true,
        initiallyExpanded: Bool = true,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where S: StringProtocol, Label == MenuSectionText<Text> {
        self.label = MenuSectionText(label)
        self.divider = divider
        _isExpanded = .constant(false) // not used
        nonBindingInitiallyExpanded = initiallyExpanded
        self.content = content
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        divider: Bool = true,
        initiallyExpanded: Bool = true,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where Label == MenuSectionText<Text> {
        label = MenuSectionText(titleKey)
        self.divider = divider
        _isExpanded = .constant(false) // not used
        nonBindingInitiallyExpanded = initiallyExpanded
        self.content = content
    }
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource,
        divider: Bool = true,
        initiallyExpanded: Bool = true,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where Label == MenuSectionText<Text> {
        label = MenuSectionText(titleResource)
        self.divider = divider
        _isExpanded = .constant(false) // not used
        nonBindingInitiallyExpanded = initiallyExpanded
        self.content = content
    }
    
    public init<LabelContent: View>(
        divider: Bool = true,
        initiallyExpanded: Bool = true,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View],
        @ViewBuilder label: () -> LabelContent
    ) where Label == MenuSectionText<LabelContent> {
        
        self.divider = divider
        _isExpanded = .constant(false) // not used
        nonBindingInitiallyExpanded = initiallyExpanded
        self.label = MenuSectionText(label())
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

#endif
