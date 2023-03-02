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
        .menuBarExtraStyle(.window) // required for menu builder
        .menuBarExtraAccess(isPresented: $isMenuPresented) // required for menu builder
    }
}

struct MenuView: View {
    @Binding var isMenuPresented: Bool
    
    @State private var darkMode: Bool = true
    @State private var nightShift: Bool = true
    @State private var trueTone: Bool = true
    @State private var volume: CGFloat = 0.75
    @State private var brightness: CGFloat = 0.5
    @State private var selectedItem: Int = 0
    
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
            
            MacControlCenterPanel {
                HStack {
                    MacControlCenterCircleToggle(
                        isOn: $darkMode,
                        style: .prominent,
                        color: .white,
                        invertForeground: true,
                        image: .macControlCenterAirplayVideo
                    ) { Text("Dark Mode") }
                    MacControlCenterCircleToggle(
                        isOn: $nightShift,
                        style: .prominent,
                        color: .orange,
                        image: .macControlCenterDisplayBrightness
                    ) { Text("Night Shift") }
                    MacControlCenterCircleToggle(
                        isOn: $trueTone,
                        style: .prominent,
                        color: .blue,
                        image: .macControlCenterDisplayBrightness
                    ) { Text("True Tone") }
                }
            }
            
            Divider()
            
            MacControlCenterVolumeSlider("Sound", value: $volume)
                .frame(minWidth: sliderWidth)
            
            ForEach(0...6, id: \.self) { num in
                MacControlCenterCircleToggle(
                    "Selectable Menu Item \(num)",
                    isOn: .constant(selectedItem == num),
                    image: .macControlCenterSpeaker
                ) { _ in
                    selectedItem = num
                }
            }
            
            Divider()
            
            MacControlCenterCircleButton(
                image: .macControlCenterAirplayVideo,
                label: { Text("Command Button With a Really Long Name That will Get Truncated") }
            ) {
                isMenuPresented = false // dismiss the window
                print("Button pressed.")
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
