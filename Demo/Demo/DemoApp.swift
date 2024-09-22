//
//  DemoApp.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MacControlCenterUI

@main
struct DemoApp: App {
    @State var isMenuPresented: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .windowLevel(.floating)
        .defaultPosition(.center)
        
        Settings {
            SettingsView()
        }
        
        MenuBarExtra("MacControlCenterUI Demo", systemImage: "message.fill") {
            MenuView(isMenuPresented: $isMenuPresented)
        }
        .menuBarExtraStyle(.window) // required for menu builder
        .menuBarExtraAccess(isPresented: $isMenuPresented) // required for menu builder
    }
}

// MARK: App Lifecycle & Global

func activateApp() {
    NSApp.activate(ignoringOtherApps: true)
}

/// This still works on macOS 14 thankfully.
func showStandardAboutWindow() {
    NSApp.sendAction(
        #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
        to: nil,
        from: nil
    )
}

func quit() {
    NSApp.terminate(nil)
}
