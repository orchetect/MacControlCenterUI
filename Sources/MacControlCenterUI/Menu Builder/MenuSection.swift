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
    
    // MARK: Init
    
    public init<S>(
        _ label: S
    ) where S: StringProtocol, Label == MenuSectionText {
        self.label = MenuSectionText(text: Text(label))
    }
    
    public init(
        _ titleKey: LocalizedStringKey
    ) where Label == MenuSectionText {
        self.label = MenuSectionText(text: Text(titleKey))
    }
    
    public init(
        @ViewBuilder _ label: () -> Label
    ) {
        self.label = label()
    }
    
    // MARK: Body
    
    public var body: some View {
        Divider()
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
