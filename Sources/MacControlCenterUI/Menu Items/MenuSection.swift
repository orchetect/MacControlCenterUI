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
public struct MenuSection<Label: View>: View, MacControlCenterMenuItem {
    // MARK: Public Properties
    
    public var label: Label?
    public var divider: Bool
    public var content: [any View]?
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: Private State
    
    @State private var height: CGFloat = 0
    
    // MARK: Init - With Label, No Content
    
    @_disfavoredOverload
    public init<S>(
        _ label: S,
        divider: Bool = true
    ) where S: StringProtocol, Label == MenuSectionText<Text> {
        self.label = MenuSectionText(text: Text(label))
        self.divider = divider
        self.content = nil
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        divider: Bool = true
    ) where Label == MenuSectionText<Text> {
        label = MenuSectionText(text: Text(titleKey))
        self.divider = divider
        self.content = nil
    }
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource,
        divider: Bool = true
    ) where Label == MenuSectionText<Text> {
        label = MenuSectionText(text: Text(titleResource))
        self.divider = divider
        self.content = nil
    }
    
    @_disfavoredOverload
    public init(
        _ label: Text,
        divider: Bool = true
    ) where Label == MenuSectionText<Text> {
        self.label = MenuSectionText(text: label)
        self.divider = divider
        self.content = nil
    }
    
    /// Initialize Menu Section with custom label.
    /// Note that the standard menu section header text formatting is not applied when using this initializer.
    public init<LabelContent: View>(
        divider: Bool = true,
        @ViewBuilder _ label: () -> LabelContent
    ) where Label == MenuSectionText<LabelContent> {
        self.label = MenuSectionText(label())
        self.divider = divider
        self.content = nil
    }
    
    // MARK: Init - With Label, With Content
    
    @_disfavoredOverload
    public init<S>(
        _ label: S,
        divider: Bool = true,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) where S: StringProtocol, Label == MenuSectionText<Text> {
        self.label = MenuSectionText(text: Text(label))
        self.divider = divider
        self.content = content()
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        divider: Bool = true,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) where Label == MenuSectionText<Text> {
        label = MenuSectionText(text: Text(titleKey))
        self.divider = divider
        self.content = content()
    }
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource,
        divider: Bool = true,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) where Label == MenuSectionText<Text> {
        label = MenuSectionText(text: Text(titleResource))
        self.divider = divider
        self.content = content()
    }
    
    @_disfavoredOverload
    public init(
        _ label: Text,
        divider: Bool = true,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) where Label == MenuSectionText<Text> {
        self.label = MenuSectionText(text: label)
        self.divider = divider
        self.content = content()
    }
    
    /// Initialize Menu Section with custom label.
    /// Note that the standard menu section header text formatting is not applied when using this initializer.
    public init<LabelContent: View>(
        divider: Bool = true,
        @MacControlCenterMenuBuilder content: () -> [any View],
        @ViewBuilder label: () -> LabelContent
    ) where Label == MenuSectionText<LabelContent> {
        self.label = MenuSectionText(label())
        self.divider = divider
        self.content = content()
    }
    
    // MARK: Init - No Label, With Content
    
    public init(
        divider: Bool = true,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) where Label == Never {
        self.label = nil
        self.divider = divider
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        viewBody
            .geometryGroupIfSupportedByPlatform()
    }
    
    @ViewBuilder
    public var viewBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                if divider {
                    MenuBody {
                        Divider()
                    }
                }
                
                if let label {
                    MenuBody {
                        label
                            .opacity(isEnabled ? 1.0 : 0.4)
                    }
                }
            }
            .geometryGroupIfSupportedByPlatform()
            
            contentBody
        }
    }
    
    @ViewBuilder
    private var contentBody: some View {
        if let content {
            MenuBody(content: content) { item in
                item
                    }
        }
    }
}

#if DEBUG
#Preview("Label, No Content") {
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuSection("Section", divider: false)
        
        MenuCommand("Test Menu Item") { }
        MenuCommand("Test Menu Item") { }
        
        MenuSection("Section", divider: true)
        
        MenuCommand("Test Menu Item") { }
        MenuCommand("Test Menu Item") { }
        
        MenuSection("Section", divider: true)
        
        MenuSection(divider: false) {
            MenuCommand("Test Menu Item") { }
            MenuCommand("Test Menu Item") { }
        }
    }
}

#Preview("Label, With Content") {
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuSection("Section", divider: false) {
            MenuCommand("Test Menu Item") { }
            MenuCommand("Test Menu Item") { }
        }
        
        MenuSection("Section", divider: true) {
            MenuCommand("Test Menu Item") { }
            MenuCommand("Test Menu Item") { }
        }
    }
}
#endif

#endif
