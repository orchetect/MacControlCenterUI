//
//  MenuSection.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Header ``MacControlCenterMenu`` menu entry with section label.
/// Typically used as the first item in a menu to enable an entire menu's functionality.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuSection<Label: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    
    public var label: Label
    public var divider: Bool
    
    // MARK: Init
    
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
    }
}

public struct MenuSectionText: View {
    @Environment(\.colorScheme) private var colorScheme
    
    public let text: Text
    
    public var body: some View {
        text
            .font(.system(size: MenuStyling.headerFontSize, weight: .semibold))
            .foregroundColor(
                colorScheme == .dark
                    ? Color(white: 1).opacity(0.6)
                    : Color(white: 0).opacity(0.7)
            )
    }
}
