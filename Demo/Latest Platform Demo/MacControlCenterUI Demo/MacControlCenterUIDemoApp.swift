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

struct MenuEntry: Hashable, Identifiable {
    let name: String
    let image: Image
    let imageColor: Color?
    
    // Identifiable
    var id: String { name }
    
    // Hashable - custom since Image isn't Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(name: String, image: Image, imageColor: Color? = nil) {
        self.name = name
        self.image = image
        self.imageColor = imageColor
    }
    
    init(name: String, systemImage: String, imageColor: Color? = nil) {
        self.name = name
        self.image = Image(systemName: systemImage)
        self.imageColor = imageColor
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
    @State private var isWiFiExpanded = true
    @State private var audioOutputSelection: MenuEntry.ID? = "MacBook Pro Microphone"
    @State private var wifiSelection: MenuEntry.ID? = nil
    @State private var shapeSelection: MenuEntry.ID? = nil
    @State private var testPlain = false
    
    @State var audioOutputs: [MenuEntry] = [
        .init(name: "MacBook Pro Speakers", systemImage: "laptopcomputer"),
        .init(name: "Display Audio", systemImage: "speaker.wave.2.fill"),
        .init(name: "Tim's AirPods Max", systemImage: "airpodsmax"),
        .init(name: "AppleTV", systemImage: "appletv.fill")
    ]
    
    static func randomWiFiImage() -> Image {
        Image(systemName: "wifi", variableValue: Double.random(in: 0.2...1.0)) // random signal strength
    }
    
    @State var wifiNetworks: [MenuEntry] = [
        .init(name: "Wi-Fi Art Thou Romeo", image: Self.randomWiFiImage()),
        .init(name: "Drop It Like It's Hotspot", image: Self.randomWiFiImage()),
        .init(name: "Panic At The Cisco", image: Self.randomWiFiImage()),
        .init(name: "Lord Of The Pings", image: Self.randomWiFiImage()),
        .init(name: "Hide Yo Kids Hide Yo Wi-Fi", image: Self.randomWiFiImage()),
        .init(name: "DLINK45892", image: Self.randomWiFiImage())
    ]
    
    @State var shapes: [MenuEntry] = [
        .init(name: "Circle", systemImage: "circle.fill", imageColor: .green),
        .init(name: "Square", systemImage: "square.fill", imageColor: .orange),
        .init(name: "Triangle", systemImage: "triangle.fill", imageColor: .purple)
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
                        controlSize: .prominent,
                        style: .init(
                            image: .macControlCenterAirplayVideo,
                            color: .white,
                            invertForeground: true
                        )
                    ) { Text("Dark Mode") }
                    MacControlCenterCircleToggle(
                        isOn: $nightShift,
                        controlSize: .prominent,
                        style: .init(
                            image: .macControlCenterDisplayBrightness,
                            color: .orange
                        )
                    ) { Text("Night Shift") }
                    MacControlCenterCircleToggle(
                        isOn: $trueTone,
                        controlSize: .prominent,
                        style: .init(
                            image: .macControlCenterDisplayBrightness,
                            color: .blue
                        )
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
            
            MenuList(audioOutputs, selection: $audioOutputSelection) { item, isSelected, itemClicked in
                if item.name == "Tim's AirPods Max" {
                    MenuDisclosureGroup(style: .menuItem, initiallyExpanded: false, labelHeight: .controlCenterIconItem) {
                        MenuToggle(isOn: .constant(isSelected), image: item.image) {
                            HStack {
                                Text(item.name)
                                Spacer()
                                HStack(spacing: 2) {
                                    Text("82%").foregroundColor(.secondary)
                                    Image(systemName: "battery.75", variableValue: 0.82).foregroundColor(.secondary)
                                }.frame(height: 10)
                            }
                        } onClick: { _ in itemClicked() }
                    } content: {
                        let airPodsOptions: [MenuEntry] = [
                            .init(name: "Off", systemImage: "person.fill"),
                            .init(name: "Noise Cancellation", systemImage: "person.fill"),
                            .init(name: "Transparency", systemImage: "person.fill")
                        ]
                        MenuList(airPodsOptions, selection: .constant("Off")) { item, isSelected, itemClicked in
                            MenuToggle(
                                isOn: .constant(isSelected),
                                style: .checkmark()
                            ) {
                                HStack {
                                    item.image
                                    Text(item.name).font(.system(size: 12))
                                    Spacer()
                                }
                            } onClick: { _ in itemClicked() }
                        }
                    }
                } else {
                     MenuToggle(isOn: .constant(isSelected), image: item.image) {
                        Text(item.name)
                    } onClick: { _ in itemClicked() }
                }
            }

            MenuDisclosureSection("Wi-Fi Network", isExpanded: $isWiFiExpanded) {
                MenuScrollView(maxHeight: 130) {
                    MenuList(wifiNetworks, selection: $wifiSelection) { item in
                        MenuToggle(image: item.image) {
                            Text(item.name)
                        }
                    }
                }
            }
            
//            MenuDisclosureSection("Shapes", initiallyExpanded: false) {
//                MenuCommand("Test") { }
//                MenuCommand("Test") { }
//                MenuCommand("Test") { }
//                MenuList(shapes) { item in
//                    MenuCommand {
//                        print("\(item.name) pressed.")
//                    } label: {
//                        HStack {
//                            item.image
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(item.imageColor?.opacity(0.8))
//                                .frame(width: 24, height: 24)
//                            Text(item.name)
//                            Spacer()
//                        }
//                    }
//                    CustomMenuStateItem { item in
//                        HStack {
//                            item.image
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(item.imageColor?.opacity(0.8))
//                                .frame(width: 24, height: 24)
//                            Text(item.name)
//                            Spacer()
//                        }
//                        .frame(height: 30)
//                        .onTapGesture {
//                            isMenuPresented = false // manually dismiss window
//                            print("\(item.name) pressed.")
//                        }
//                    }
//                }
//            }
            
            Divider()
            
            MenuToggle(
                isOn: $testPlain,
                style: .init(image: nil, color: .orange, offColor: .orange.opacity(0.2))
            ) {
                Text("Custom State Colors Without Image")
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
        .background(VisualEffect.nonVibrant())
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
