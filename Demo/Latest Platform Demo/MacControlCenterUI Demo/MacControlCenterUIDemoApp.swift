//
//  AppDelegate.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MacControlCenterUI

@main
struct MacControlCenterUIDemoApp: App {
    //@Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        MenuBarExtra("MacControlCenterUI Demo", systemImage: "slider.horizontal.3") {
            Menu()
        }
        .menuBarExtraStyle(.window)
    }
}

struct Menu: View {
    @State private var volume: CGFloat = 0.75
    @State private var brightness: CGFloat = 0.5
    @State private var item1: Bool = false
    
    /// Based on macOS Control Center slider width
    let sliderWidth: CGFloat = 270
    
    var body: some View {
        MacControlCenterMenu {
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
            
            // standard macOS-style button
            Button("Test") {
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
    
    // MARK: Helpers
    
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
