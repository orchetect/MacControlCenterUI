//
//  MenuSettingsCommand.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import SwiftUI

/// ``MenuSettingsCommand`` is a ``MenuCommand`` variant used to open the application's Settings 
/// scene.
///
/// Provides the same functionality as `SettingsLink` on macOS 14 and later, while providing
/// styling and compatibility for MacControlCenterUI menus.
///
/// As a convenience, this method is backwards compatible and will use legacy methods on macOS 13
/// and older in order to invoke the Settings scene.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuSettingsCommand<Label: View>: View, MacControlCenterMenuItem {
    private let label: Label
    private let activatesApp: Bool
    private let dismissesMenu: Bool
    
    @_disfavoredOverload
    public init<S>(
        _ title: S,
        activatesApp: Bool = true,
        dismissesMenu: Bool = true
    ) where S: StringProtocol, Label == Text {
        self.label = Text(title)
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        activatesApp: Bool = true,
        dismissesMenu: Bool = true
    ) where Label == Text {
        self.label = Text(titleKey)
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
    }
    
    public init(
        activatesApp: Bool = true,
        dismissesMenu: Bool = true,
        @ViewBuilder label: () -> Label
    ) {
        self.label = label()
        self.activatesApp = activatesApp
        self.dismissesMenu = dismissesMenu
    }
    
    public var body: some View {
        MenuCommand(
            activatesApp: activatesApp,
            dismissesMenu: dismissesMenu,
            settingsLink: { label }
        )
    }
}

#endif
