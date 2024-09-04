//
//  MenuView.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MacControlCenterUI
import MenuBarExtraAccess
import SettingsAccess

struct MenuView: View {
    // SettingsAccess method to open Settings with backwards-compatibility on older macOS versions
    @Environment(\.openSettingsLegacy) var openSettingsLegacy
    
    @Binding var isMenuPresented: Bool
    
    @State private var darkMode: Bool = true
    @State private var nightShift: Bool = true
    @State private var trueTone: Bool = true
    @State private var volume: CGFloat = 0.75
    @State private var brightness: CGFloat = 0.5
    @State private var selectedItem: Int = 0
    @State private var isWiFiExpanded = true
    @State private var audioOutputSelection: MenuEntry.ID? = "Tim's AirPods Max"
    @State private var airPodsOptionSelection: MenuEntry.ID? = "Off"
    @State private var wifiSelection: MenuEntry.ID? = "Wi-Fi Art Thou Romeo"
    @State private var shapeSelection: MenuEntry.ID? = nil
    @State private var testPlain = false
    
    @State var audioOutputs: [MenuEntry] = MockData.audioOutputs
    @State var airPodsOptions: [MenuEntry] = MockData.airPodsOptions
    @State var wifiNetworks: [MenuEntry] = MockData.wifiNetworks
    
    /// Based on macOS Control Center slider width
    let sliderWidth: CGFloat = 270
    
    var body: some View {
        MacControlCenterMenu(isPresented: $isMenuPresented) {
            MenuHeader("Demo App") {
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
            
            MenuSection("Display")
            
            MenuSlider(
                value: $brightness,
                image: Image(systemName: "sun.max.fill")
            )
            .frame(minWidth: sliderWidth)
            
            HStack {
                MenuCircleToggle(
                    isOn: $darkMode,
                    controlSize: .prominent,
                    style: .init(
                        image: Image(systemName: "airplayvideo"),
                        color: .white,
                        invertForeground: true
                    )
                ) { Text("Dark Mode") }
                MenuCircleToggle(
                    isOn: $nightShift,
                    controlSize: .prominent,
                    style: .init(
                        image: Image(systemName: "sun.max.fill"),
                        color: .orange
                    )
                ) { Text("Night Shift") }
                MenuCircleToggle(
                    isOn: $trueTone,
                    controlSize: .prominent,
                    style: .init(
                        image: Image(systemName: "sun.max.fill"),
                        color: .blue
                    )
                ) { Text("True Tone") }
            }
            .frame(height: 80)
            
            MenuSection("Sound")
            
            MenuVolumeSlider(value: $volume)
                .frame(minWidth: sliderWidth)
            
            MenuCommand("Sound Settings...") {
                print("Sound Settings clicked")
            }
            
            MenuSection("Output")
            
            MenuList(audioOutputs, selection: $audioOutputSelection) { item, isSelected, itemClicked in
                if item.name.contains("AirPods Max") {
                    MenuDisclosureGroup(
                        style: .menuItem,
                        initiallyExpanded: false,
                        labelHeight: .controlCenterIconItem,
                        fullLabelToggle: false,
                        toggleVisibility: .always
                    ) {
                        MenuToggle(isOn: .constant(isSelected), image: item.image) {
                            HStack {
                                Text(item.name)
                                Spacer()
                                HStack(spacing: 2) {
                                    Text("82%")
                                    Image(systemName: "battery.75", variableValue: 0.82)
                                }
                                .frame(height: 10)
                                .opacity(0.7)
                                Spacer().frame(width: 28) // room for chevron
                            }
                        } onClick: { _ in itemClicked() }
                    } content: {
                        MenuList(airPodsOptions, selection: $airPodsOptionSelection) { item, isSelected, itemClicked in
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
                MenuScrollView(maxHeight: 135) {
                    MenuList(wifiNetworks, selection: $wifiSelection) { item in
                        MenuToggle(image: item.image) {
                            Text(item.name)
                        }
                    }
                }
            }
            
            Divider()
            
            MenuCommand {
                showStandardAboutWindow()
            } label: {
                Text("About") // custom label view
            }
            
            // An alternative way to open Settings without using SettingsLink
            // that is backwards compatible with older macOS versions.
            MenuCommand {
                try? openSettingsLegacy()
            } label: {
                Text("Settings...") // custom label view
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
}
