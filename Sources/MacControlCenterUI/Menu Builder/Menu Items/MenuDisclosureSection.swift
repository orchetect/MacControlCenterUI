//
//  DisclosureMenuSection.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Disclosure section for ``MacControlCenterMenu`` menu entry with section label.
/// Used to hide or show optional content in a menu, akin to a submenu.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct DisclosureMenuSection<Label: View>: View, MacControlCenterMenuItem {
    public var label: Label
    public var divider: Bool
    @Binding public var isExpanded: Bool
    public var content: [any View]
    
    @State private var isHighlighted = false
    
    // MARK: Init
    
    public init<S>(
        _ label: S,
        divider: Bool = true,
        isExpanded: Binding<Bool>,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) where S: StringProtocol, Label == MenuSectionText {
        self.label = MenuSectionText(text: Text(label))
        self.divider = divider
        self._isExpanded = isExpanded
        self.content = content()
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        divider: Bool = true,
        isExpanded: Binding<Bool>,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) where Label == MenuSectionText {
        self.label = MenuSectionText(text: Text(titleKey))
        self.divider = divider
        self._isExpanded = isExpanded
        self.content = content()
    }
    
    public init(
        divider: Bool = true,
        isExpanded: Binding<Bool>,
        @ViewBuilder _ label: () -> Label,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) {
        self.divider = divider
        self._isExpanded = isExpanded
        self.label = label()
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        if divider {
            MenuBody {
                Divider()
            }
        }
        
        HighlightingMenuItem(
            style: .controlCenter,
            height: 20,
            isHighlighted: $isHighlighted
        ) {
            HStack {
                label
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.primary)
                    .rotationEffect(isExpanded ? .degrees(90) : .zero)
//                    .animation(.default, value: isExpanded)
            }
        }
        .onTapGesture {
//            withAnimation(.spring()) {
                isExpanded.toggle()
//            }
            
            // below is some jank magic to make the window not freak out too much
            height = isExpanded ? nil : 0
            minHeight = isExpanded ? 0 : nil
            DispatchQueue.main.async {
                minHeight = nil
            }
        }
        
        // do not remove the view using if { } otherwise it loses state
        MenuBody(content: content)
            .frame(minHeight: minHeight)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .opacity(isExpanded ? 1 : 0)
        
            .onAppear {
                if !isExpanded {
                    height = 0
                }
            }
    }
    
    @State private var height: CGFloat?
    @State private var minHeight: CGFloat?
}