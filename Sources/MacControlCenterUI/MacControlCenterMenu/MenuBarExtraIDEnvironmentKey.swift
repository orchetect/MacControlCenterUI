//
//  MenuBarExtraIDEnvironmentKey.swift
//  MenuBarExtraAccess • https://github.com/orchetect/MenuBarExtraAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension EnvironmentValues {
    /// MenuBarExtra ID.
    var menuBarExtraIsPresented: Binding<Bool> {
        get { self[MenuBarExtraIsPresentedEnvironmentKey.self] }
        set { self[MenuBarExtraIsPresentedEnvironmentKey.self] = newValue }
    }
}

private struct MenuBarExtraIsPresentedEnvironmentKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}
