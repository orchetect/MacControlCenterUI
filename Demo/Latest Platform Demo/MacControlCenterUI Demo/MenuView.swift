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
    
    @State private var model = MenuModel()
    
    @Binding var isMenuPresented: Bool
    
    var body: some View {
        MacControlCenterMenu(isPresented: $isMenuPresented) {
            MenuSection("Display", divider: false)
            
            MenuSlider(
                value: $model.brightness,
                image: Image(systemName: "sun.max.fill")
            )
            .frame(minWidth: MenuModel.sliderWidth)
            
            HStack {
                MenuCircleToggle(
                    isOn: $model.darkMode,
                    controlSize: .prominent,
                    style: .init(
                        image: Image(systemName: "airplayvideo"),
                        color: .white,
                        invertForeground: true
                    )
                ) { Text("Dark Mode") }
                MenuCircleToggle(
                    isOn: $model.nightShift,
                    controlSize: .prominent,
                    style: .init(
                        image: Image(systemName: "sun.max.fill"),
                        color: .orange
                    )
                ) { Text("Night Shift") }
                MenuCircleToggle(
                    isOn: $model.trueTone,
                    controlSize: .prominent,
                    style: .init(
                        image: Image(systemName: "sun.max.fill"),
                        color: .blue
                    )
                ) { Text("True Tone") }
            }
            .frame(height: 80)
            
            MenuSection("Sound")
            
            MenuVolumeSlider(value: $model.volume)
                .frame(minWidth: MenuModel.sliderWidth)
            
            MenuCommand("Sound Settings...") {
                print("Sound Settings clicked")
            }
            
            MenuSection("Output")
            
            MenuList(model.audioOutputs, selection: $model.audioOutputSelection) { item, isSelected, itemClicked in
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
                        MenuList(model.airPodsOptions, selection: $model.airPodsOptionSelection) { item, isSelected, itemClicked in
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
            
            MenuDisclosureSection("Wi-Fi Network", isExpanded: $model.isWiFiExpanded) {
                MenuScrollView(maxHeight: 135) {
                    MenuList(model.wiFiNetworks, selection: $model.wiFiSelection) { item in
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
}
