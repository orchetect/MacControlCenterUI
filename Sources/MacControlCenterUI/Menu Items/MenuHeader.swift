//
//  MenuHeader.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// ``MacControlCenterMenu`` header label menu item with leading label content and optional trailing content.
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
    ) where S: StringProtocol, Label == Text, TrailingContent == Never {
        self.label = Self.stylized(Text(label))
        trailingContent = nil
    }
    
    public init(
        _ titleKey: LocalizedStringKey
    ) where Label == Text, TrailingContent == Never {
        label = Self.stylized(Text(titleKey))
        trailingContent = nil
    }
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource
    ) where Label == Text, TrailingContent == Never {
        label = Self.stylized(Text(titleResource))
        trailingContent = nil
    }
    
    public init(
        @ViewBuilder _ label: () -> Label
    ) where TrailingContent == Never {
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
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource,
        @ViewBuilder trailingContent: @escaping () -> TrailingContent
    ) where Label == Text {
        label = Self.stylized(Text(titleResource))
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
        conditionalHeightBody
            .geometryGroupIfSupportedByPlatform()
            .opacity(isEnabled ? 1.0 : 0.4)
            
    }
    
    @ViewBuilder
    private var conditionalHeightBody: some View {
        if trailingContent == nil {
            headerBody
                .frame(height: MenuGeometry.menuItemContentStandardHeight)
        } else {
            headerBody
        }
    }
    
    @ViewBuilder
    private var headerBody: some View {
        HStack {
            label
            Spacer()
            if let trailingContent {
                trailingContent
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private static func stylized(_ text: Text) -> Text {
        text
            .font(.system(size: MenuStyling.headerFontSize, weight: .bold))
    }
}

#if DEBUG
@available(macOS 14, *)
#Preview("Text Only Header") {
    @Previewable @State var isOn: Bool = true
    @Previewable @State var isKeyboardOn: Bool = true
    @Previewable @State var isTrackpadOn: Bool = false
    
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuHeader("Bluetooth")
        
        Divider()
        
        MenuToggle("Keyboard", isOn: $isKeyboardOn, style: .standard(systemImage: "keyboard"))
        MenuToggle("Trackpad", isOn: $isTrackpadOn, style: .standard(systemImage: "rectangle.and.hand.point.up.left.filled"))
        
        Divider()
        
        MenuCommand("Bluetooth Settings...") { }
    }
}

@available(macOS 14, *)
#Preview("Header With Trailing Content") {
    @Previewable @State var isOn: Bool = true
    @Previewable @State var isKeyboardOn: Bool = true
    @Previewable @State var isTrackpadOn: Bool = false
    
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuHeader("Bluetooth") {
            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .labelsHidden()
        }
        
        Divider()
        
        MenuToggle("Keyboard", isOn: $isKeyboardOn, style: .standard(systemImage: "keyboard"))
        MenuToggle("Trackpad", isOn: $isTrackpadOn, style: .standard(systemImage: "rectangle.and.hand.point.up.left.filled"))
        
        Divider()
        
        MenuCommand("Bluetooth Settings...") { }
    }
}
#endif

#endif
