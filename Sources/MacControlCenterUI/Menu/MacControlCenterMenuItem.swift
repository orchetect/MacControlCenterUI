//
//  MacControlCenterMenuItem.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

// MARK: - Menu Item Protocol

/// Internal use only.
/// It is not necessary to conform your views to this protocol unless you require custom view padding in a ``MacControlCenterMenu``.
@MainActor public protocol MacControlCenterMenuItem where Self: View { }

// MARK: - SwiftUI View Modifier Overrides to Retain Protocol Typing

extension MacControlCenterMenuItem {
    /// Return self type-erased to `some View`.
    nonisolated var selfAsView: some View { self }
    
    /// Adds a condition that controls whether users can interact with this
    /// view.
    ///
    /// The higher views in a view hierarchy can override the value you set on
    /// this view. In the following example, the button isn't interactive
    /// because the outer `disabled(_:)` modifier overrides the inner one:
    ///
    ///     HStack {
    ///         Button(Text("Press")) {}
    ///         .disabled(false)
    ///     }
    ///     .disabled(true)
    ///
    /// - Parameter disabled: A Boolean value that determines whether users can
    ///   interact with this view.
    ///
    /// - Returns: A view that controls whether users can interact with this
    ///   view.
    public func disabled(_ disabled: Bool) -> some MacControlCenterMenuItem {
        MacControlCenterMenuItemWrapper(
            content: selfAsView.disabled(disabled)
        )
    }
}

/// Generic wrapper for arbitrary view content to conform to ``MacControlCenterMenuItem``
struct MacControlCenterMenuItemWrapper<Content: View>: View, MacControlCenterMenuItem {
    let content: Content
    
    var body: some View {
        content
    }
}

#endif
