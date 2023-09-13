//
//  SettingsLinkButtonStyle.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

/// Allows calling code before and/or after user clicks a `SettingsLink` button/command.
/// This is a necessary workaround, as it is simply not possible to attach a simultaneous gesture to
/// `SettingsLink`.
struct SettingsLinkButtonStyle: PrimitiveButtonStyle {
    public let preTapAction: (() -> Void)?
    public let postTapAction: (() -> Void)?
    
    public init(preTapAction: (() -> Void)?, postTapAction: (() -> Void)?) {
        self.preTapAction = preTapAction
        self.postTapAction = postTapAction
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onTapGesture {
                preTapAction?()
                configuration.trigger() // open Settings window
                postTapAction?()
            }
    }
}

private struct SettingsLinkButtonStyleModifier: ViewModifier {
    let preTapAction: (() -> Void)?
    let postTapAction: (() -> Void)?
    
    func body(content: Content) -> some View {
        content.buttonStyle(
            SettingsLinkButtonStyle(preTapAction: preTapAction, postTapAction: postTapAction)
        )
    }
}

extension View {
    /// Conveience to apply `SettingsLinkButtonStyle`.
    func settingsLinkButtonStyle(
        preTapAction: (() -> Void)? = nil,
        postTapAction: (() -> Void)? = nil
    ) -> some View {
        modifier(
            SettingsLinkButtonStyleModifier(preTapAction: preTapAction, postTapAction: postTapAction)
        )
    }
}

#endif
