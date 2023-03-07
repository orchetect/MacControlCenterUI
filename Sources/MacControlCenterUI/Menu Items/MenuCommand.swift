//
//  MenuCommand.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

/// ``MacControlCenterMenu`` menu item that acts like a traditional `NSMenuItem` that highlights
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
    @Environment(\.isMenuBarExtraPresented) private var menuBarExtraIsPresented
    
    public var label: Label
    public var action: (() -> Void)
    public var activatesApp: Bool = true
    public var dismissesMenu: Bool = true
    public var style: MenuCommandStyle = .controlCenter
    
    @State public var isHighlighted: Bool = false
    
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
        HighlightingMenuItem(
            style: style,
            height: .standardTextOnly,
            isHighlighted: $isHighlighted
        ) {
            HStack {
                label
                    .foregroundColor(style.textColor(hover: isHighlighted))
                Spacer()
            }
        }
        .onTapGesture {
            switch style {
            case .menu:
                // classic NSMenu-style menu commands still blink on click, as of Ventura
                blinkThenCallAction()
            case .controlCenter:
                // Control Center menu commands don't blink because Apple is boring and hates charm
                callAction()
            }
        }
    }
    
    // MARK: Helpers
    
    private func blinkThenCallAction() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            isHighlighted = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isHighlighted = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            callAction()
        }
    }
    
    private func callAction() {
        if activatesApp {
            NSApp.activate(ignoringOtherApps: true)
        }
        
        if dismissesMenu {
            menuBarExtraIsPresented.wrappedValue = false
        }
        
        action()
    }
}
