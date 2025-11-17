//
//  MenuView.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import MacControlCenterUI
import MenuBarExtraAccess
import SwiftUI

struct MenuView: View {
    @Environment(\.openSettings) var openSettings
    
    @Binding var isMenuPresented: Bool
    
    @State private var isCommandsDisabled = false
    @State private var darkMode: Bool = true
    @State private var nightShift: Bool = true
    @State private var trueTone: Bool = true
    @State private var volume: CGFloat = 0.75
    @State private var brightness: CGFloat = 0.5
    @State private var audioOutputSelection: MenuEntry.ID? = MockData.audioOutputsDefault
    @State private var airPodsOptionSelection: MenuEntry.ID? = MockData.airPodsOptionsDefault
    @State private var isWiFiExpanded = true
    @State private var wiFiSelection: MenuEntry.ID? = MockData.wiFiNetworksDefault
    @State private var audioOutputs: [MenuEntry] = MockData.audioOutputs
    @State private var airPodsOptions: [MenuEntry] = MockData.airPodsOptions
    @State private var wiFiNetworks: [MenuEntry] = MockData.wiFiNetworks
    @State private var isSafariEnabled: Bool = true
    @State private var isMusicEnabled: Bool = true
    @State private var isXcodeEnabled: Bool = false
    
    var body: some View {
        MacControlCenterMenu(isPresented: $isMenuPresented) {
            MenuSection("Display", divider: false)
            
            MenuSlider(
                value: $brightness,
                image: Image(systemName: "sun.max.fill")
            )
            .disabled(isCommandsDisabled)
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
                ) {
                    Text("Dark Mode")
                }
                MenuCircleToggle(
                    isOn: $nightShift,
                    controlSize: .prominent,
                    style: .init(
                        image: Image(systemName: "sun.max.fill"),
                        color: .orange
                    )
                ) {
                    Text("Night Shift")
                }
                MenuCircleToggle(
                    isOn: $trueTone,
                    controlSize: .prominent,
                    style: .init(
                        image: Image(systemName: "sun.max.fill"),
                        color: .blue
                    )
                ) {
                    Text("True Tone")
                }
                .disabled(isCommandsDisabled)
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
                    HighlightingMenuDisclosureGroup(
                        style: .menuItem,
                        initiallyExpanded: false,
                        labelHeight: .controlCenterIconItem,
                        toggleVisibility: .always, // <-- try setting to .onHover!
                        label: {
                            MenuCircleToggle(isOn: .constant(isSelected), image: item.image) {
                                HStack {
                                    Text(item.name)
                                    Spacer()
                                    HStack(spacing: 2) {
                                        Text("82%")
                                        Image(systemName: "battery.75", variableValue: 0.82)
                                    }
                                    .frame(height: 10)
                                    .opacity(0.7)
                                }
                            } onClick: { _ in
                                itemClicked()
                            }
                        },
                        content: {
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
                                } onClick: { _ in
                                    itemClicked()
                                }
                            }
                        }
                    )
                    .disabled(isCommandsDisabled)
                } else {
                    MenuToggle(isOn: .constant(isSelected), image: item.image) {
                        Text(item.name)
                    } onClick: { _ in itemClicked() }
                }
            }
            
            MenuDisclosureSection("Wi-Fi Network", isExpanded: $isWiFiExpanded) {
                MenuScrollView(maxHeight: 135) {
                    MenuList(wiFiNetworks, selection: $wiFiSelection) { item in
                        MenuToggle(image: item.image) {
                            Text(item.name)
                        }
                    }
                    .disabled(isCommandsDisabled)
                }
            }
            
            MenuSection("Custom Icons")
            MenuToggle("Safari", isOn: $isSafariEnabled, style: .icon(appIcon(for: "com.apple.Safari")))
            MenuToggle("Music", isOn: $isMusicEnabled, style: .icon(appIcon(for: "com.apple.Music")))
            MenuToggle("Xcode", isOn: $isXcodeEnabled, style: .icon(appIcon(for: "com.apple.dt.Xcode")))
                .disabled(isCommandsDisabled)
            
            MenuSection("Debug")
                .disabled(isCommandsDisabled)
            
            MenuCircleToggle(
                "Disable Some Menu Items",
                isOn: $isCommandsDisabled,
                image: Image(systemName: "rectangle.slash")
            )
            
            Divider()
            
            MenuCommand {
                showStandardAboutWindow()
            } label: {
                Text("About") // custom label view
            }
            .disabled(isCommandsDisabled)
            
            MenuCommand {
                openSettings()
            } label: {
                Text("Settings...") // custom label view
            }
            
            Divider()
            
            MenuCommand("Quit") {
                quit()
            }
        }
    }
}
