//
//  MenuDisclosureGroup.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// ``MacControlCenterMenu`` disclosure group menu item.
/// Used to hide or show optional content in a menu.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuDisclosureGroup<Label: View>: View, MacControlCenterMenuItem {
    public var style: MenuDisclosureGroupStyle
    public var labelHeight: MenuItemSize
    public var label: Label
    public var labelToggle: Bool
    public var content: [any View]
    @Binding public var isExpandedBinding: Bool
    @State private var isExpanded: Bool
    
    @State private var isPressed: Bool = false
    @State private var isHighlighted = false
    
    // MARK: Init - With Binding
    
    public init(
        style: MenuDisclosureGroupStyle,
        isExpanded: Binding<Bool>,
        labelHeight: MenuItemSize,
        labelToggle: Bool = false,
        @ViewBuilder label: () -> Label,
        @MacControlCenterMenuBuilder content: () -> [any View]
    ) {
        self.style = style
        self._isExpandedBinding = isExpanded
        self._isExpanded = State(initialValue: isExpanded.wrappedValue)
        self.labelHeight = labelHeight
        self.labelToggle = labelToggle
        self.label = label()
        self.content = content()
    }
    
    // MARK: Init - Without Binding
    
    public init(
        style: MenuDisclosureGroupStyle,
        initiallyExpanded: Bool = true,
        labelHeight: MenuItemSize,
        labelToggle: Bool = false,
        @ViewBuilder label: () -> Label,
        @MacControlCenterMenuBuilder content: () -> [any View]
    ) {
        self.style = style
        self._isExpandedBinding = .constant(initiallyExpanded)
        self._isExpanded = State(initialValue: initiallyExpanded)
        self.labelHeight = labelHeight
        self.labelToggle = labelToggle
        self.label = label()
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        if labelToggle {
            highlightingButtonLabelContent
        } else {
            regularLabelContent
        }
        
        // do not remove the view using if { } otherwise it loses state
        expandedContent
            .frame(minHeight: minContentHeight)
            .frame(maxWidth: .infinity)
            .frame(height: contentHeight)
            .opacity(isExpanded ? 1 : 0)
        
            .onAppear {
                if !isExpanded {
                    contentHeight = 0
                }
            }
        
            .onChange(of: isExpandedBinding) { newValue in
                isExpanded = newValue
            }
            .onChange(of: isExpanded) { newValue in
                isExpandedBinding = newValue
            }
    }
    
    private var highlightingButtonLabelContent: some View {
        HighlightingMenuStateItem(
            style: .controlCenter,
            height: labelHeight,
            isOn: $isExpanded,
            isPressed: $isPressed
        ) {
            HStack {
                label
                Spacer()
                chevron
            }
        } onChange: { _ in
            disclosureClicked()
        }
    }
    
    private var regularLabelContent: some View {
        ZStack {
            HStack {
                label
            }
            HStack(spacing: 0) {
                Spacer()
                chevron
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isExpanded.toggle()
                        disclosureClicked()
                    }
                Spacer().frame(width: MenuGeometry.menuHorizontalContentInset)
            }
        }
    }
    
    private var chevron: some View {
        Image(systemName: "chevron.right")
            .resizable()
            .scaledToFit()
            .frame(width: 10, height: 10)
            .foregroundColor(.primary)
            .rotationEffect(isExpanded ? .degrees(90) : .zero)
            //.animation(.default, value: isExpanded)
    }
    
    private func disclosureClicked() {
        // below is some jank magic to make the window not freak out too much
        contentHeight = isExpanded ? nil : 0
        minContentHeight = isExpanded ? 0 : nil
        DispatchQueue.main.async {
            minContentHeight = nil
        }
    }
    
    @State private var contentHeight: CGFloat?
    @State private var minContentHeight: CGFloat?
    
    @ViewBuilder
    private var expandedContent: some View {
        switch style {
        case .section:
            MenuBody(content: content)
        case .menuItem:
            FullWidthMenuItem {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(.gray.opacity(0.5))
                        .frame(height: 1)
                    
                    ZStack {
                        Rectangle().fill(.gray.opacity(0.15))
                        MenuBody(content: content)
                    }
                    .padding([.top, .bottom], 1)
                    
                    Rectangle()
                        .fill(.gray.opacity(0.7))
                        .frame(height: 1)
                }
            }
        }
    }
}

public enum MenuDisclosureGroupStyle {
    /// Section style: Expanded content body has no added background (transparent).
    case section
    
    /// Menu item style: Expanded content body has a shaded background.
    case menuItem
}
