//
//  DemoApp.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import MacControlCenterUI
import SwiftUI

@main
struct DemoApp: App {
    @State private var model = MenuModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultPosition(.center)

        Settings {
            SettingsView()
        }

        MenuBarExtra("MacControlCenterUI Demo", systemImage: "message.fill") {
            MenuView()
                .environment(model)
        }
        .menuBarExtraAccess(isPresented: $model.isMenuPresented) // required for menu builder
        .menuBarExtraStyle(.window) // required for menu builder
        .windowResizability(.contentSize) // this modifier is not necessary; it may affect menu height animations. YMMV.
    }
}

// MARK: App Lifecycle & Global

@MainActor
func activateApp() {
    NSApp.activate(ignoringOtherApps: true)
}

/// This still works on macOS 14 thankfully.
@MainActor
func showStandardAboutWindow() {
    NSApp.sendAction(
        #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
        to: nil,
        from: nil
    )
}

@MainActor
func quit() {
    NSApp.terminate(nil)
}
