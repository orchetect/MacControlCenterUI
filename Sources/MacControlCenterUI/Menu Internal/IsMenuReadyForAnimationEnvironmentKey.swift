//
//  IsMenuReadyForAnimationEnvironmentKey.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

extension EnvironmentValues {
    /// Key determining whether ``MacControlCenterMenu`` is ready for animation.
    /// Defaults to `false` to ensure initial presentation of the menu is static.
    /// Thereafter, this key is set to `true` to allow menu layout changes to animate.
    var isMenuReadyForAnimation: Bool {
        get { self[IsMenuReadyForAnimationEnvironmentKey.self] }
        set { self[IsMenuReadyForAnimationEnvironmentKey.self] = newValue }
    }
}

private struct IsMenuReadyForAnimationEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

#endif
