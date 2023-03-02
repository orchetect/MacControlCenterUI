//
//  MenuCommand.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

/// ``MacControlCenterMenu`` menu entry that acts like a traditional `NSMenuItem` that highlights
/// when moused over and is clickable with a custom action closure.
///
/// Menu hover colorization can be set using the ``menuCommandStyle(_:)`` view modifier:
///  `menu` style (highlight color) or `commandCenter` style (translucent gray).
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuCommand<Label: View>: View, MacControlCenterMenuItem {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.menuBarExtraIsPresented) private var menuBarExtraIsPresented
    
    public var label: Label
    public var action: (() -> Void)
    public var activatesApp: Bool = true
    public var dismissesMenu: Bool = true
    public var style: MenuCommandStyle = .controlCenter
    
    @State private var mouseIsHovering: Bool = false
    
    // MARK: Init
    
    public init<S>(
        _ title: S,
        activatesApp: Bool = true,
        dismissesMenu: Bool = true,
        action: @escaping (() -> Void)
    ) where S: StringProtocol, Label == Text {
        self.label = Text(title)
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
        self.action = action
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        activatesApp: Bool = true,
        dismissesMenu: Bool = true,
        action: @escaping (() -> Void)
    ) where Label == Text {
        self.label = Text(titleKey)
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
        self.action = action
    }
    
    public init(
        action: @escaping (() -> Void),
        activatesApp: Bool = true,
        dismissesMenu: Bool = true,
        @ViewBuilder label: () -> Label
    ) {
        self.label = label()
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
        self.action = action
    }
    
    // MARK: Body
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: .init(width: 5, height: 5))
                .fill(style.backColor(hover: mouseIsHovering) ?? .clear)
                .padding([.leading, .trailing], menuHorizontalHighlightInset)
            
            VStack(alignment: .leading) {
                HStack {
                    label
                        .foregroundColor(style.textColor(hover: mouseIsHovering))
                    Spacer()
                }
            }
            .padding([.leading, .trailing], menuHorizontalContentInset)
        }
        .frame(height: menuItemContentStandardHeight + menuItemPadding)
        .onHover { state in
            if mouseIsHovering != state {
                mouseIsHovering = state
            }
        }
        .onTapGesture {
            blinkAndCallAction()
        }
    }
    
    // MARK: Helpers
    
    private func blinkAndCallAction() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            mouseIsHovering = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            mouseIsHovering = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [activatesApp, dismissesMenu, action] in
            if activatesApp {
                NSApp.activate(ignoringOtherApps: true)
            }
            
            if dismissesMenu {
                menuBarExtraIsPresented.wrappedValue = false
            }
            
            action()
        }
    }
}
