//
//  MenuSection.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// ``MacControlCenterMenu`` section label menu item with optional divider.
/// Typically macOS Control Center menus have a divider prior to each section to cleanly divide up
/// the interface.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuSection<Label: View>: View {
    // MARK: Public Properties
    
    public var label: Label
    public var divider: Bool
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: Init
    
    @_disfavoredOverload
    public init<S>(
        _ label: S,
        divider: Bool = true
    ) where S: StringProtocol, Label == MenuSectionText<Text> {
        self.label = MenuSectionText(text: Text(label))
        self.divider = divider
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        divider: Bool = true
    ) where Label == MenuSectionText<Text> {
        label = MenuSectionText(text: Text(titleKey))
        self.divider = divider
    }
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource,
        divider: Bool = true
    ) where Label == MenuSectionText<Text> {
        label = MenuSectionText(text: Text(titleResource))
        self.divider = divider
    }
    
    @_disfavoredOverload
    public init(
        _ label: Text,
        divider: Bool = true
    ) where Label == MenuSectionText<Text> {
        self.label = MenuSectionText(text: label)
        self.divider = divider
    }
    
    /// Initialize Menu Section with custom label.
    /// Note that the standard menu section header text formatting is not applied when using this initializer.
    public init<LabelContent: View>(
        divider: Bool = true,
        @ViewBuilder _ label: () -> LabelContent
    ) where Label == MenuSectionText<LabelContent> {
        self.label = MenuSectionText(label())
        self.divider = divider
    }
    
    // MARK: Body
    
    public var body: some View {
        if divider { Divider() }
        
        label
            .opacity(isEnabled ? 1.0 : 0.4)
    }
}

#if DEBUG
#Preview {
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuSection("Section", divider: false)
        
        MenuCommand("Test Menu Item") { }
        MenuCommand("Test Menu Item") { }
        
        MenuSection("Section", divider: true)
        
        MenuCommand("Test Menu Item") { }
        MenuCommand("Test Menu Item") { }
    }
    .frame(width: 310)
}
#endif

#endif
