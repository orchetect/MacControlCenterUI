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
    
    @State private var isEnabled = true
    @State private var isUUIDContentShown = false
    @State private var isUUIDContentAnimated = true
    @State private var uuidContentItems: [UUID] = (0 ... 9).map { _ in UUID() }
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
    
    init(isMenuPresented: Binding<Bool>) {
        _isMenuPresented = isMenuPresented
    }
    
    var body: some View {
        MacControlCenterMenu(isPresented: $isMenuPresented) {
            // If state changes may result menu height changing, it is recommended to use the `macControlCenterMenuResize`
            // animation constant which replicates menu height change animations.
            MenuHeader("Enabled") {
                Toggle("", isOn: $isEnabled.animation(.macControlCenterMenuResize))
                    .toggleStyle(.switch)
                    .labelsHidden()
            }
            
            // To prevent layout animation glitches, if there is menu content that may appear/disappear,
            // it is best to place it within a stable `MenuSection` container which will always be present.
            MenuSection(divider: false) {
                if !isEnabled {
                    Text("Some menu items are now disabled.")
                        .foregroundStyle(.secondary)
                }
            }
            
            // To prevent layout animation glitches, if there is menu content that may change height,
            // it is best to place it within a stable `MenuSection` container which will always be present.
            MenuSection {
                MenuToggle(
                    isOn: $isUUIDContentShown.animation(isUUIDContentAnimated ? .macControlCenterMenuResize : nil),
                    image: Image(systemName: "questionmark.circle")
                ) {
                    Text("Show UUIDs")
                        .fixedSize()
                    Spacer()
                    Toggle("Animate Changes", isOn: $isUUIDContentAnimated)
                        .toggleStyle(.switch)
                        .controlSize(.mini)
                        .textScale(.secondary)
                        .fixedSize()
                }
                
                if isUUIDContentShown {
                    ForEach(uuidContentItems, id: \.self) { uuid in
                        Text(uuid.uuidString)
                    }
                    .font(.callout)
                    .monospaced()
                    .foregroundStyle(.secondary)
                    
                    MenuCircleButton(style: .standard(systemImage: "plus")) {
                        withAnimation(isUUIDContentAnimated ? .macControlCenterMenuResize : nil) {
                            uuidContentItems.append(contentsOf: (0 ... 9).map { _ in UUID() })
                        }
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Add more content")
                            Text("To test menu animation and scrolling.")
                                .multilineTextAlignment(.leading)
                                .textScale(.secondary)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            
            MenuSection("Display", divider: true) {
                MenuSlider(
                    value: $brightness,
                    image: .minMax(minSystemName: "sun.min.fill", maxSystemName: "sun.max.fill")
                )
                .disabled(!isEnabled)
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
                    .disabled(!isEnabled)
                }
                .frame(height: 80)
            }
            
            MenuSection("Sound", divider: true) {
                MenuVolumeSlider(value: $volume)
                    .frame(minWidth: sliderWidth)
                
                MenuCommand("Sound Settings...") {
                    print("Sound Settings clicked")
                }
            }
            
            MenuSection("Output", divider: true) {
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
                        .disabled(!isEnabled)
                    } else {
                        MenuToggle(isOn: .constant(isSelected), image: item.image) {
                            Text(item.name)
                        } onClick: { _ in itemClicked() }
                    }
                }
            }
            
            MenuDisclosureSection("Wi-Fi Network", divider: true, isExpanded: $isWiFiExpanded) {
                MenuScrollView(maxHeight: 135) {
                    MenuList(wiFiNetworks, selection: $wiFiSelection) { item in
                        MenuToggle(image: item.image) {
                            Text(item.name)
                        }
                    }
                    .disabled(!isEnabled)
                }
            }
            
            MenuSection("Custom Icons", divider: true) {
                MenuToggle("Safari", isOn: $isSafariEnabled, style: .icon(appIcon(for: "com.apple.Safari")))
                MenuToggle("Music", isOn: $isMusicEnabled, style: .icon(appIcon(for: "com.apple.Music")))
                    .disabled(!isEnabled)
            }
            
            MenuSection(divider: true) {
                MenuCommand {
                    showStandardAboutWindow()
                } label: {
                    Text("About") // custom label view
                }
                .disabled(!isEnabled)
                
                MenuCommand {
                    openSettings()
                } label: {
                    Text("Settings...") // custom label view
                }
            }
            
            MenuSection(divider: true) {
                MenuCommand(height: .auto) {
                    print("Custom-size menu command clicked")
                } label: {
                    Text("Non-Standard Height Command")
                    Text("A brief description of this command that describes what it does.")
                        .foregroundStyle(.secondary)
                        .textScale(.secondary)
                }
                
                MenuCommand(style: .plain, height: .auto) {
                    print("Custom-size menu command clicked")
                } label: { action in
                    Text("Non-Standard Height Command With Proxy")
                    HStack {
                        Text("Example:")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button("Action Proxy") { action() }
                        Button("Custom Action") { print("Custom action without dismissing menu") }
                    }
                    .textScale(.secondary)
                    .buttonStyle(.link)
                }
            }
            
            MenuSection(divider: true) {
                MenuCommand("Quit") {
                    quit()
                }
            }
        }
    }
}
