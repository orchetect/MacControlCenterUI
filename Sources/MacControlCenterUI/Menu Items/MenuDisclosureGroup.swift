//
//  MenuDisclosureGroup.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// ``MacControlCenterMenu`` disclosure group menu item.
/// Used to hide or show optional content in a menu.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuDisclosureGroup<Label: View>: View, MacControlCenterMenuItem {
    // MARK: Public Properties
    
    public var style: MenuDisclosureGroupStyle
    public var labelHeight: MenuItemSize
    public var toggleVisibility: ControlVisibility
    public var label: Label
    public var isFullLabelToggle: Bool
    public var content: [any View]
    @Binding public var isExpandedBinding: Bool
    
    // MARK: Environment
    
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: Private State
    
    @State private var isExpanded: Bool
    @State private var isPressed: Bool = false
    @State private var isHighlighted: Bool = false
    
    // MARK: Init - With Binding
    
    public init(
        style: MenuDisclosureGroupStyle,
        isExpanded: Binding<Bool>,
        labelHeight: MenuItemSize,
        fullLabelToggle: Bool = false,
        toggleVisibility: ControlVisibility = .always,
        @ViewBuilder label: () -> Label,
        @MacControlCenterMenuBuilder content: () -> [any View]
    ) {
        self.style = style
        _isExpandedBinding = isExpanded
        _isExpanded = State(initialValue: isExpanded.wrappedValue)
        self.labelHeight = labelHeight
        self.isFullLabelToggle = fullLabelToggle
        self.toggleVisibility = toggleVisibility
        self.label = label()
        self.content = content()
    }
    
    // MARK: Init - Without Binding
    
    public init(
        style: MenuDisclosureGroupStyle,
        initiallyExpanded: Bool = true,
        labelHeight: MenuItemSize,
        fullLabelToggle: Bool = false,
        toggleVisibility: ControlVisibility = .always,
        @ViewBuilder label: () -> Label,
        @MacControlCenterMenuBuilder content: () -> [any View]
    ) {
        self.style = style
        _isExpandedBinding = .constant(initiallyExpanded)
        _isExpanded = State(initialValue: initiallyExpanded)
        self.labelHeight = labelHeight
        self.isFullLabelToggle = fullLabelToggle
        self.toggleVisibility = toggleVisibility
        self.label = label()
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        viewBody
            .geometryGroupIfSupportedByPlatform()
            .onChange(of: isExpandedBinding) { newValue in
                withAnimation(.macControlCenterMenuResize) { isExpanded = newValue }
            }
            .onChange(of: isExpanded) { newValue in
                withAnimation(.macControlCenterMenuResize) { isExpandedBinding = newValue }
            }
    }
    
    @ViewBuilder
    public var viewBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                if isFullLabelToggle {
                    highlightingButtonLabelContent
                } else {
                    regularLabelContent
                }
            }
            .geometryGroupIfSupportedByPlatform()
            .animation(nil, value: isExpanded)
            
            if isExpanded {
                expandedContent
            }
        }
    }
    
    @State private var expandedContentSize: CGSize?
    
    private var highlightingButtonLabelContent: some View {
        HighlightingMenuStateItem(
            style: .controlCenter,
            height: labelHeight,
            isOn: $isExpanded.animation(.macControlCenterMenuResize),
            isHighlighted: $isHighlighted,
            isPressed: $isPressed
        ) {
            HStack {
                labelFormatted
                Spacer()
                if isChevronVisible {
                    MenuDisclosureChevron(isExpanded: $isExpanded.animation(.macControlCenterMenuResize))
                }
            }
        }
    }
    
    private var regularLabelContent: some View {
        ZStack {
            HStack {
                labelFormatted
            }
            HStack(spacing: 0) {
                Spacer()
                if isChevronVisible {
                    MenuDisclosureChevron(isExpanded: $isExpanded.animation(.macControlCenterMenuResize))
                }
                Spacer()
                    .frame(width: MenuGeometry.menuHorizontalContentInset)
            }
        }
        .onHover { state in
            guard isEnabled else { return }
            isHighlighted = state
        }
        .onChange(of: isEnabled) { newValue in
            if !isEnabled {
                isHighlighted = false
            }
        }
    }
    
    private var labelFormatted: some View {
        label.opacity(isEnabled ? 1.0 : 0.4)
    }
    
    private var isChevronVisible: Bool {
        guard toggleVisibility != .never else { return false }
        return isExpanded || isHighlighted || toggleVisibility == .always
    }
    
    @ViewBuilder
    private var expandedContent: some View {
        FullWidthMenuItem(verticalPadding: false) {
            Group {
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
            .frame(maxWidth: .infinity)
            .scrollDisabledIfSupportedByPlatform(false) // counterbalance to `true` in viewBody
        }
    }
}

#endif
