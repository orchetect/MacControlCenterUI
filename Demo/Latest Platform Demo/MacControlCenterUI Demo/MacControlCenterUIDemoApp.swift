//
//  MacControlCenterUIDemoApp.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MacControlCenterUI
import MenuBarExtraAccess
import SettingsAccess

@main
struct MacControlCenterUIDemoApp: App {
    @State var isMenuPresented: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(isMenuPresented: $isMenuPresented)
                .openSettingsAccess() // SettingsAccess method to open Settings
        }
        .windowResizability(.contentSize)
        
        Settings {
            SettingsView()
        }
        
        MenuBarExtra("MacControlCenterUI Demo", systemImage: "message.fill") {
            MenuView(isMenuPresented: $isMenuPresented)
                .openSettingsAccess()
        }
        .menuBarExtraStyle(.window) // required for menu builder
        .menuBarExtraAccess(isPresented: $isMenuPresented) // required for menu builder
    }
}
