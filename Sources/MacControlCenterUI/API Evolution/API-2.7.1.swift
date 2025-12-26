//
//  API-2.7.1.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

extension MenuCommand {
    @_documentation(visibility: internal)
    @_disfavoredOverload
    @available(*, deprecated, renamed: "init(activatesApp:action:label:)")
    public init(
        action: @MainActor @escaping () -> Void,
        activatesApp: Bool,
        @ViewBuilder label: @MainActor @escaping () -> Label
    ) {
        self.init(
            activatesApp: activatesApp,
            action: action,
            label: label
        )
    }
    
    @_documentation(visibility: internal)
    @_disfavoredOverload
    @available(*, deprecated, renamed: "init(dismissesMenu:action:label:)")
    public init(
        action: @MainActor @escaping () -> Void,
        dismissesMenu: Bool,
        @ViewBuilder label: @MainActor @escaping () -> Label
    ) {
        self.init(
            dismissesMenu: dismissesMenu,
            action: action,
            label: label
        )
    }
    
    @_documentation(visibility: internal)
    @_disfavoredOverload
    @available(*, deprecated, renamed: "init(activatesApp:dismissesMenu:action:label:)")
    public init(
        action: @MainActor @escaping () -> Void,
        activatesApp: Bool,
        dismissesMenu: Bool,
        @ViewBuilder label: @MainActor @escaping () -> Label
    ) {
        self.init(
            activatesApp: activatesApp,
            dismissesMenu: dismissesMenu,
            action: action,
            label: label
        )
    }
}

extension MenuCommand {
    /// Apply a menu command style.
    @_documentation(visibility: internal)
    @available(*, deprecated, message: "This view modifier is deprecated. MenuCommand initializers now have a `style` parameter.")
    public func menuCommandStyle(_ style: MenuCommandStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }
}

#endif
