//
//  API-2.7.1.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

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
