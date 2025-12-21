//
//  DemoApp.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import MacControlCenterUI
import SwiftUI

@main
struct DemoApp: App {
    @State var isMenuPresented: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultPosition(.center)
        
        Settings {
            SettingsView()
        }
        
        MenuBarExtra("MacControlCenterUI Demo", systemImage: "message.fill") {
            MenuView(isMenuPresented: $isMenuPresented)
        }
        .menuBarExtraStyle(.window) // required for menu builder
        .menuBarExtraAccess(isPresented: $isMenuPresented) // required for menu builder
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
