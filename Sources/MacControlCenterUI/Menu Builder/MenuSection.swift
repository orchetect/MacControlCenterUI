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
    public var label: Label
    
    // MARK: Init
    
    public init<S>(
        _ label: S
    ) where S: StringProtocol, Label == Text{
        self.label = Self.stylized(Text(label))
    }
    
    public init(
        _ titleKey: LocalizedStringKey
    ) where Label == Text {
        self.label = Self.stylized(Text(titleKey))
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
    
    private static func stylized(_ text: Text) -> Text {
        text
            .font(.system(size: MenuStyling.headerFontSize, weight: .bold))
            .foregroundColor(.secondary)
    }
}
