//
//  DisclosureMenuSection.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Disclosure section ``MacControlCenterMenu`` menu entry with section label.
/// Used to hide or show optional content in a menu, akin to a submenu.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DisclosureMenuSection<Label: View, Content: View>: View, MacControlCenterMenuItem {
    public var label: Label
    @Binding public var isExpanded: Bool
    public var content: Content
    
    @State private var isHighlighted = false
    
    // MARK: Init
    
    public init<S>(
        _ label: S,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) where S: StringProtocol, Label == Text{
        self.label = Self.stylized(Text(label))
        self._isExpanded = isExpanded
        self.content = content()
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) where Label == Text {
        self.label = Self.stylized(Text(titleKey))
        self._isExpanded = isExpanded
        self.content = content()
    }
    
    public init(
        isExpanded: Binding<Bool>,
        @ViewBuilder _ label: () -> Label,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isExpanded = isExpanded
        self.label = label()
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        MenuBody {
            Divider()
        }
        HighlightingMenuItem(
            style: .controlCenter,
            height: 20,
            isHighlighted: $isHighlighted
        ) {
            HStack {
                label
                Spacer()
                Text(">")
                    .foregroundColor(.primary)
            }
        }
        .onTapGesture {
            //withAnimation {
            isExpanded.toggle()
            //}
        }
        
        if isExpanded {
            //withAnimation {
            content
            //}
        }
    }
    
    private static func stylized(_ text: Text) -> Text {
        text
            .font(.system(size: MenuStyling.headerFontSize, weight: .bold))
            .foregroundColor(.secondary)
    }
}
