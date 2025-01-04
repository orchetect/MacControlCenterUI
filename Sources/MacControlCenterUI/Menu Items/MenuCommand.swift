//
//  MenuCommand.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

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
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isMenuBarExtraPresented) private var menuBarExtraIsPresented
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: Private State
    
    private let label: Label
    private let action: () -> Void
    var activatesApp: Bool
    var dismissesMenu: Bool
    var style: MenuCommandStyle = .controlCenter
    @State private var isHighlighted: Bool = false
    
    // MARK: Init
    
    @_disfavoredOverload
    public init<S>(
        _ title: S,
        activatesApp: Bool = true,
        dismissesMenu: Bool = true,
        action: @escaping () -> Void
    ) where S: StringProtocol, Label == Text {
        label = Text(title)
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
        self.action = action
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        activatesApp: Bool = true,
        dismissesMenu: Bool = true,
        action: @escaping () -> Void
    ) where Label == Text {
        label = Text(titleKey)
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
        self.action = action
    }
    
    public init(
        action: @escaping () -> Void,
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
            commandBody
                .allowsHitTesting(isEnabled)
                .onTapGesture {
                    guard isEnabled else { return }
                    userTapped()
                }
        }
    }
    
    private var commandBody: some View {
        HStack {
            label
                .foregroundColor(style.textColor(hover: isHighlighted, isEnabled: isEnabled))
            Spacer()
        }
        .contentShape(Rectangle())
    }
    
    // MARK: Helpers
    
    private func userTapped() {
        func go() {
            if activatesApp {
                NSApp.activate(ignoringOtherApps: true)
            }
            
            Task {
                if dismissesMenu {
                    menuBarExtraIsPresented.wrappedValue = false
                    // wait a small amount to give the menu a chance to close before calling the action block
                    try? await Task.sleep(nanoseconds: 100 * NSEC_PER_MSEC) // 100 ms
                }
                
                action()
            }
        }
        
        // classic NSMenu-style menu commands still blink on click.
        // for a few macOS releases starting with macOS 11, Control Center style menu commands did not blink,
        // but at some point (macOS 14 or 15) Apple added this behavior back in to match the NSMenu behavior.
        Task {
            isHighlighted = false
            try? await Task.sleep(nanoseconds: 80 * NSEC_PER_MSEC) // 80 ms
            isHighlighted = true
            try? await Task.sleep(nanoseconds: 80 * NSEC_PER_MSEC) // 80 ms
            go()
        }
    }
}

#endif
