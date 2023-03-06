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

struct AudioDevice: Hashable, Identifiable {
    let name: String
    var id: String { name }
}

struct MenuView: View {
    @Binding var isMenuPresented: Bool
    
    @State private var darkMode: Bool = true
    @State private var nightShift: Bool = true
    @State private var trueTone: Bool = true
    @State private var volume: CGFloat = 0.75
    @State private var brightness: CGFloat = 0.5
    @State private var selectedItem: Int = 0
    @State private var isOutputExpanded = true
    @State private var inputSelection: AudioDevice.ID? = "Test In 1"
    @State private var outputSelection: AudioDevice.ID? = nil
    @State private var testPlain = false
    
    @State var inputs: [AudioDevice] = [
        .init(name: "Test In 1"),
        .init(name: "Test In 2"),
        .init(name: "Test In 3")
    ]
    
    @State var outputs: [AudioDevice] = [
        .init(name: "Test Out 1"),
        .init(name: "Test Out 2"),
        .init(name: "Test Out 3"),
        .init(name: "Test Out 4"),
        .init(name: "Test Out 5"),
        .init(name: "Test Out 6")
    ]
    
    /// Based on macOS Control Center slider width
    let sliderWidth: CGFloat = 270
    
    var body: some View {
        MacControlCenterMenu(isPresented: $isMenuPresented) {
            MenuHeader("Demo App") {
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
            
            MenuSection("Display")
            
            MacControlCenterSlider(
                value: $brightness,
                image: .macControlCenterDisplayBrightness
            )
            .frame(minWidth: sliderWidth)
            
            // MacControlCenterPanel {
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
            // }
                .frame(height: 80)
            
            MenuSection("Sound")
            
            MacControlCenterVolumeSlider(value: $volume)
                .frame(minWidth: sliderWidth)
            
            MenuCommand("Sound Settings...") {
                showSettingsWindow()
            }
            
            MenuSection("Input")
            
            MenuRadioGroup(inputs, selection: $inputSelection) { item in
                Text(item.name)
            }
            
            DisclosureMenuSection("Output", isExpanded: $isOutputExpanded) {
                MenuScrollView(maxHeight: 130) {
                    MenuRadioGroup(outputs, selection: $outputSelection) { item in
                        Text(item.name)
                    }
                }
            }
            
            Divider()
            
            MacControlCenterCircleToggle(
                isOn: $testPlain,
                style: .menu,
                color: .red,
                offColor: .red.opacity(0.2)
            ) {
                Text("Custom Colors with No Image")
            }
            
            Divider()
            
            MenuCommand {
                showStandardAboutWindow()
            } label: {
                Text("About") // custom label view
            }
            
            MenuCommand("Settings...") {
                showSettingsWindow()
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
    
    func showStandardAboutWindow() {
        NSApp.sendAction(
            #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
            to: nil,
            from: nil
        )
    }
    
    func showSettingsWindow() {
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
