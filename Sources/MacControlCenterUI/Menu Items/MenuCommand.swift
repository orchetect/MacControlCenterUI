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
    
    private let label: @MainActor (_ action: @MainActor @escaping () -> Void) -> Label
    private let action: @MainActor () -> Void
    var activatesApp: Bool
    var dismissesMenu: Bool
    var style: MenuCommandStyle = .controlCenter
    var height: MenuItemSize = .standardTextOnly
    var spacing: CGFloat
    @State private var isHighlighted: Bool = false
    
    // MARK: Init
    
    @_disfavoredOverload
    public init<S>(
        _ title: S,
        style: MenuCommandStyle = .controlCenter,
        height: MenuItemSize = .standardTextOnly,
        spacing: CGFloat = 0,
        activatesApp: Bool = true,
        dismissesMenu: Bool = true,
        action: @MainActor @escaping () -> Void
    ) where S: StringProtocol, Label == Text {
        label = { _ in Text(title) }
        self.style = style
        self.height = height
        self.spacing = spacing
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
        self.action = action
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        style: MenuCommandStyle = .controlCenter,
        height: MenuItemSize = .standardTextOnly,
        spacing: CGFloat = 0,
        activatesApp: Bool = true,
        dismissesMenu: Bool = true,
        action: @MainActor @escaping () -> Void
    ) where Label == Text {
        label = { _ in Text(titleKey) }
        self.style = style
        self.height = height
        self.spacing = spacing
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
        self.action = action
    }
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource,
        style: MenuCommandStyle = .controlCenter,
        height: MenuItemSize = .standardTextOnly,
        spacing: CGFloat = 0,
        activatesApp: Bool = true,
        dismissesMenu: Bool = true,
        action: @MainActor @escaping () -> Void
    ) where Label == Text {
        label = { _ in Text(titleResource) }
        self.style = style
        self.height = height
        self.spacing = spacing
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
        self.action = action
    }
    
    public init(
        style: MenuCommandStyle = .controlCenter,
        height: MenuItemSize = .standardTextOnly,
        spacing: CGFloat = 0,
        activatesApp: Bool = true,
        dismissesMenu: Bool = true,
        action: @MainActor @escaping () -> Void,
        @ViewBuilder label: @MainActor @escaping () -> Label
    ) {
        self.label = { _ in label() }
        self.style = style
        self.height = height
        self.spacing = spacing
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
        self.action = action
    }
    
    public init(
        style: MenuCommandStyle = .controlCenter,
        height: MenuItemSize = .standardTextOnly,
        spacing: CGFloat = 0,
        activatesApp: Bool = true,
        dismissesMenu: Bool = true,
        action: @MainActor @escaping () -> Void,
        @ViewBuilder label: @MainActor @escaping (_ action: @MainActor @escaping () -> Void) -> Label
    ) {
        self.label = label
        self.style = style
        self.height = height
        self.spacing = spacing
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
        self.action = action
    }
    
    // MARK: Body
    
    public var body: some View {
        HighlightingMenuItem(
            style: style,
            height: height,
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
        ZStack(alignment: .leading) {
            Color.clear
            
            VStack(alignment: .leading, spacing: spacing) {
                label(userTapped)
            }
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
                    try? await Task.sleep(seconds: 0.100) // 100 ms
                }
                
                action()
            }
        }
        
        // classic NSMenu-style menu commands still blink on click.
        // for one or two macOS releases macOS 12 (I believe, for one), Control Center style menu commands did not blink,
        // but at some point (macOS 14 or 15) Apple added this behavior back in to match the NSMenu behavior.
        Task {
            isHighlighted = false
            try? await Task.sleep(seconds: 0.080) // 80 ms
            isHighlighted = true
            try? await Task.sleep(seconds: 0.080) // 80 ms
            go()
        }
    }
}

#endif
