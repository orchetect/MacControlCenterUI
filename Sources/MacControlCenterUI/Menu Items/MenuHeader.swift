//
//  MenuHeader.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// ``MacControlCenterMenu`` header label menu item with leading label content, optional trailing
/// content, and optional divider.
/// Typically used as the first item in a menu, to establish the functionality contained within.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuHeader<Label: View, TrailingContent: View>: View {
    // MARK: Public Properties
    
    public var label: Label
    public var trailingContent: TrailingContent?
    
    // MARK: Environment
    
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: Init without Trailing Content
    
    @_disfavoredOverload
    public init<S>(
        _ label: S
    ) where S: StringProtocol, Label == Text {
        self.label = Self.stylized(Text(label))
        trailingContent = nil
    }
    
    public init(
        _ titleKey: LocalizedStringKey
    ) where Label == Text {
        label = Self.stylized(Text(titleKey))
        trailingContent = nil
    }
    
    public init(
        @ViewBuilder _ label: () -> Label
    ) where TrailingContent == EmptyView {
        self.label = label()
        trailingContent = nil
    }
    
    // MARK: Init with Trailing Content
    
    @_disfavoredOverload
    public init<S>(
        _ label: S,
        @ViewBuilder trailingContent: @escaping () -> TrailingContent
    ) where S: StringProtocol, Label == Text {
        self.label = Self.stylized(Text(label))
        self.trailingContent = trailingContent()
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        @ViewBuilder trailingContent: @escaping () -> TrailingContent
    ) where Label == Text {
        label = Self.stylized(Text(titleKey))
        self.trailingContent = trailingContent()
    }
    
    public init(
        @ViewBuilder _ label: () -> Label,
        @ViewBuilder trailingContent: @escaping () -> TrailingContent
    ) {
        self.label = label()
        self.trailingContent = trailingContent()
    }
    
    // MARK: Body
    
    public var body: some View {
        compose
            .opacity(isEnabled ? 1.0 : 0.4)
            .frame(minHeight: MenuGeometry.menuItemContentStandardHeight)
    }
    
    @ViewBuilder
    private var compose: some View {
        if let trailingContent {
            HStack {
                label
                Spacer()
                trailingContent
            }
        } else {
            label
        }
    }
    
    private static func stylized(_ text: Text) -> Text {
        text
            .font(.system(size: MenuStyling.headerFontSize, weight: .bold))
    }
}

#endif
