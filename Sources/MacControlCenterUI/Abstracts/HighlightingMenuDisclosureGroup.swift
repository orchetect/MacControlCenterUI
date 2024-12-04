//
//  HighlightingMenuDisclosureGroup.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// ``MacControlCenterMenu`` disclosure group menu item that highlights the background when the
/// mouse hovers.
/// Used to hide or show optional content in a menu.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct HighlightingMenuDisclosureGroup<Label: View>: View, MacControlCenterMenuItem {
    // MARK: Public Properties
    
    public var style: MenuDisclosureGroupStyle
    public var labelHeight: MenuItemSize
    public var toggleVisibility: ControlVisibility
    public var label: Label
    public var content: () -> [any View]
    @Binding public var isExpandedBinding: Bool
    
    // MARK: Private State
    
    @State private var isExpanded: Bool
    @State private var isHighlighted: Bool = false
    @State private var isChevronVisible: Bool
    
    // MARK: Init - With Binding
    
    public init(
        style: MenuDisclosureGroupStyle,
        isExpanded: Binding<Bool>,
        labelHeight: MenuItemSize,
        toggleVisibility: ControlVisibility = .always,
        @ViewBuilder label: () -> Label,
        @MacControlCenterMenuBuilder content: @escaping () -> [any View]
    ) {
        self.style = style
        _isExpandedBinding = isExpanded
        _isExpanded = State(initialValue: isExpanded.wrappedValue)
        self.labelHeight = labelHeight
        self.toggleVisibility = toggleVisibility
        self.label = label()
        self.content = content
        isChevronVisible = toggleVisibility == .always
    }
    
    // MARK: Init - Without Binding
    
    public init(
        style: MenuDisclosureGroupStyle,
        initiallyExpanded: Bool = true,
        labelHeight: MenuItemSize,
        toggleVisibility: ControlVisibility = .always,
        @ViewBuilder label: () -> Label,
        @MacControlCenterMenuBuilder content: @escaping () -> [any View]
    ) {
        self.style = style
        _isExpandedBinding = .constant(initiallyExpanded)
        _isExpanded = State(initialValue: initiallyExpanded)
        self.labelHeight = labelHeight
        self.toggleVisibility = toggleVisibility
        self.label = label()
        self.content = content
        isChevronVisible = toggleVisibility == .always
    }
    
    // MARK: Body
    
    public var body: some View {
        viewBody
            .onChange(of: isExpandedBinding) { newValue in
                isExpanded = newValue
            }
            .onChange(of: isExpanded) { newValue in
                isExpandedBinding = newValue
            }
    }
    
    @ViewBuilder
    public var viewBody: some View {
        MenuDisclosureGroup(
            style: style,
            isExpanded: $isExpanded,
            labelHeight: labelHeight,
            fullLabelToggle: false,
            toggleVisibility: .never,
            label: {
                HighlightingMenuItem(
                    style: .controlCenter,
                    height: labelHeight,
                    isHighlighted: $isHighlighted,
                    {
                        HStack {
                            label
                            if isChevronVisible {
                                Spacer()
                                MenuDisclosureChevron(isExpanded: $isExpanded)
                            }
                        }
                        .onChange(of: shouldChevronBeVisible) { _ in
                            withAnimation {
                                isChevronVisible = shouldChevronBeVisible
                            }
                        }
                    }
                )
            },
            content: content
        )
    }
    
    private var shouldChevronBeVisible: Bool {
        guard toggleVisibility != .never else { return false }
        return isExpanded || isHighlighted || toggleVisibility == .always
    }
}

#endif
