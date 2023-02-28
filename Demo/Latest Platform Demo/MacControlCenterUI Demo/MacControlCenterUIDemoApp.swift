//
//  MacControlCenterUIDemoApp.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MacControlCenterUI
import MenuBarExtraAccess

@main
struct MacControlCenterUIDemoApp: App {
    @State var isMenuPresented: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(isMenuPresented: $isMenuPresented)
        }
        .windowResizability(.contentSize)
        
        Settings {
            SettingsView()
        }
        
        MenuBarExtra("MacControlCenterUI Demo", systemImage: "message.fill") {
            MenuView(isMenuPresented: $isMenuPresented)
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $isMenuPresented)
    }
}

struct MenuView: View {
    @Binding var isMenuPresented: Bool
    
    @State private var volume: CGFloat = 0.75
    @State private var brightness: CGFloat = 0.5
    @State private var item1: Bool = false
    
    /// Based on macOS Control Center slider width
    let sliderWidth: CGFloat = 270
    
    var body: some View {
        MacControlCenterMenu(isPresented: $isMenuPresented) {
            MacControlCenterSlider(
                "Display",
                value: $brightness,
                image: .macControlCenterDisplayBrightness
            )
            .frame(minWidth: sliderWidth)
            
            Divider()
            
            MacControlCenterVolumeSlider("Sound", value: $volume)
                .frame(minWidth: sliderWidth)
            
            MacControlCenterCircleToggle(
                "Toggle",
                isOn: $item1,
                image: .macControlCenterSpeaker
            )
            
            MacControlCenterCircleToggle(
                "Toggle",
                isOn: $item1,
                image: .macControlCenterSpeaker
            )
            
            MacControlCenterCircleToggle(
                "Toggle",
                isOn: $item1,
                image: .macControlCenterSpeaker
            )
            
            MacControlCenterCircleToggle(
                "Toggle",
                isOn: $item1,
                image: .macControlCenterSpeaker
            )
            
            MacControlCenterCircleToggle(
                "Toggle",
                isOn: $item1,
                image: .macControlCenterSpeaker
            )
            
            MacControlCenterCircleToggle(
                "Toggle",
                isOn: $item1,
                image: .macControlCenterSpeaker
            )
            
            MacControlCenterCircleToggle(
                "Toggle",
                isOn: $item1,
                image: .macControlCenterSpeaker
            )
            
            MacControlCenterCircleToggle(
                "Toggle",
                isOn: $item1,
                image: .macControlCenterSpeaker
            )
            
            MacControlCenterCircleToggle(
                "Toggle",
                isOn: $item1,
                image: .macControlCenterSpeaker
            )
            
            MacControlCenterCircleToggle(
                "Toggle",
                isOn: $item1,
                image: .macControlCenterSpeaker
            )
            
            MacControlCenterCircleToggle(
                "Toggle",
                isOn: $item1,
                image: .macControlCenterSpeaker
            )
            
            // standard macOS-style button
            Button("Test") {
                isMenuPresented = false // dismiss the window
                print("Test pressed")
            }
            
            Divider()
            
            MenuCommand("About") {
                activateAppAndShowStandardAboutWindow()
            }
            
            MenuCommand("Settings...") {
                activateAppAndShowSettingsWindow()
            }
            
            Divider()
            
            MenuCommand("Quit") {
                quit()
            }
        }
    }
    
    // MARK: Actions
    
    func activateApp() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func activateAppAndShowStandardAboutWindow() {
        activateApp()
        NSApp.sendAction(
            #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
            to: nil,
            from: nil
        )
    }
    
    func activateAppAndShowSettingsWindow() {
        activateApp()
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }
    
    func quit() {
        NSApp.terminate(nil)
    }
}

struct ContentView: View {
    @Binding var isMenuPresented: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "message.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondary)
            
            Text("Explore this menu bar button in the system status bar.")
            
            Text("Or toggle me:")
            
            Toggle("", isOn: $isMenuPresented)
                .toggleStyle(.switch)
                .labelsHidden()
        }
        .padding()
        .frame(minWidth: 500, minHeight: 350)
        .background(VisualEffect.nonvibrant())
    }
}

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("Settings window.")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
