//
//  MenuView.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import MacControlCenterUI
import MenuBarExtraAccess
import SwiftUI

struct MenuView: View {
    @Environment(\.openSettings) private var openSettings
    @Environment(MenuModel.self) private var model

    var body: some View {
        @Bindable var model = model

        MacControlCenterMenu(isPresented: $model.isMenuPresented) {
            // If state changes may result menu height changing, it is recommended to use the `macControlCenterMenuResize`
            // animation constant which replicates menu height change animations.
            MenuHeader("Enabled") {
                Toggle("", isOn: $model.isEnabled.animation(.macControlCenterMenuResize))
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            // To prevent layout animation glitches, if there is menu content that may appear/disappear,
            // it is best to place it within a stable `MenuSection` container which will always be present.
            MenuSection(divider: false) {
                if !model.isEnabled {
                    Text("Some menu items are now disabled.")
                        .foregroundStyle(.secondary)
                }
            }

            // To prevent layout animation glitches, if there is menu content that may change height,
            // it is best to place it within a stable `MenuSection` container which will always be present.
            MenuSection {
                MenuToggle(
                    isOn: $model.isUUIDContentShown.animation(model.isUUIDContentAnimated ? .macControlCenterMenuResize : nil),
                    image: Image(systemName: "questionmark.circle")
                ) {
                    Text("Show UUIDs")
                        .fixedSize()
                    Spacer()
                    Toggle("Animate Changes", isOn: $model.isUUIDContentAnimated)
                        .toggleStyle(.switch)
                        .controlSize(.mini)
                        .textScale(.secondary)
                        .fixedSize()
                }

                if model.isUUIDContentShown {
                    ForEach(model.uuidContentItems, id: \.self) { uuid in
                        Text(uuid.uuidString)
                    }
                    .font(.system(size: 11))
                    .monospaced()
                    .foregroundStyle(.secondary)

                    MenuCircleButton(style: .standard(systemImage: "plus")) {
                        withAnimation(model.isUUIDContentAnimated ? .macControlCenterMenuResize : nil) {
                            model.addUUIDContentItems()
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
                    value: $model.brightness,
                    image: .minMax(minSystemName: "sun.min.fill", maxSystemName: "sun.max.fill")
                )
                .disabled(!model.isEnabled)

                HStack {
                    MenuCircleToggle(
                        isOn: $model.darkMode,
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
                        isOn: $model.nightShift,
                        controlSize: .prominent,
                        style: .init(
                            image: Image(systemName: "sun.max.fill"),
                            color: .orange
                        )
                    ) {
                        Text("Night Shift")
                    }
                    MenuCircleToggle(
                        isOn: $model.trueTone,
                        controlSize: .prominent,
                        style: .init(
                            image: Image(systemName: "sun.max.fill"),
                            color: .blue
                        )
                    ) {
                        Text("True Tone")
                    }
                    .disabled(!model.isEnabled)
                }
                .frame(height: 80)
            }

            MenuSection("Sound", divider: true) {
                MenuVolumeSlider(value: $model.volume)

                MenuCommand("Sound Settings...") {
                    print("Sound Settings clicked")
                }
            }

            MenuSection("Output", divider: true) {
                MenuList(model.audioOutputs, selection: $model.audioOutputSelection) { item, isSelected, itemClicked in
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
                                    } onClick: { _ in
                                        itemClicked()
                                    }
                                }
                            }
                        )
                        .disabled(!model.isEnabled)
                    } else {
                        MenuToggle(isOn: .constant(isSelected), image: item.image) {
                            Text(item.name)
                        } onClick: { _ in itemClicked() }
                    }
                }
            }

            MenuDisclosureSection("Wi-Fi Network", divider: true, isExpanded: $model.isWiFiExpanded) {
                MenuScrollView(maxHeight: 135) {
                    MenuList(model.wiFiNetworks, selection: $model.wiFiSelection) { item in
                        MenuToggle(image: item.image) {
                            Text(item.name)
                        }
                    }
                    .disabled(!model.isEnabled)
                }
            }

            MenuSection("Custom Icons", divider: true) {
                MenuToggle("Safari", isOn: $model.isSafariEnabled, style: .icon(appIcon(for: "com.apple.Safari")))
                MenuToggle("Music", isOn: $model.isMusicEnabled, style: .icon(appIcon(for: "com.apple.Music")))
                    .disabled(!model.isEnabled)
            }

            MenuSection(divider: true) {
                MenuCommand {
                    showStandardAboutWindow()
                } label: {
                    Text("About") // custom label view
                }
                .disabled(!model.isEnabled)

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
