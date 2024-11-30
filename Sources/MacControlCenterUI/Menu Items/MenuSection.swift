//
//  MenuSection.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
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
    ) where S: StringProtocol, Label == MenuSectionText {
        self.label = MenuSectionText(text: Text(label))
        self.divider = divider
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        divider: Bool = true
    ) where Label == MenuSectionText {
        self.label = MenuSectionText(text: Text(titleKey))
        self.divider = divider
    }
    
    public init(
        divider: Bool = true,
        @ViewBuilder _ label: () -> Label
    ) {
        self.label = label()
        self.divider = divider
    }
    
    // MARK: Body
    
    public var body: some View {
        if divider { Divider() }
        
        label
            .opacity(isEnabled ? 1.0 : 0.4)
    }
}

/// ``MacControlCenterMenu`` section text view.
/// This view is not commonly used by itself. It is more typical to use ``MenuSection`` instead.
public struct MenuSectionText: View {
    // MARK: Public Properties
    
    public let text: Text
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    public var body: some View {
        text
            .font(.system(size: MenuStyling.headerFontSize, weight: .semibold))
            .foregroundColor(foreColor)
    }
    
    private var foreColor: Color {
        colorScheme == .dark
            ? Color(white: 1).opacity(0.6)
            : Color(white: 0).opacity(0.7)
    }
}

#endif
