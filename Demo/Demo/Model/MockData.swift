//
//  MockData.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Mock data for the demo app UI.
enum MockData {
    static let audioOutputsDefault: MenuEntry.ID = "Tim's AirPods Max"
    static let audioOutputs: [MenuEntry] = [
        .init(name: "MacBook Pro Speakers", systemImage: "laptopcomputer"),
        .init(name: "Display Audio", systemImage: "speaker.wave.2.fill"),
        .init(name: "Tim's AirPods Max", systemImage: "airpodsmax"),
        .init(name: "AppleTV", systemImage: "appletv.fill")
    ]
    
    static let airPodsOptionsDefault: MenuEntry.ID = "Off"
    static let airPodsOptions: [MenuEntry] = [
        .init(name: "Off", systemImage: "person.fill"),
        .init(name: "Noise Cancellation", systemImage: "person.crop.circle.fill"),
        .init(name: "Transparency", systemImage: "person.wave.2.fill")
    ]
    
    static let wiFiNetworksDefault: MenuEntry.ID = "Wi-Fi Art Thou Romeo"
    static let wiFiNetworks: [MenuEntry] = [
        .init(name: "Wi-Fi Art Thou Romeo", image: .randomWiFiImage()),
        .init(name: "Drop It Like It's Hotspot", image: .randomWiFiImage()),
        .init(name: "Panic At The Cisco", image: .randomWiFiImage()),
        .init(name: "Lord Of The Pings", image: .randomWiFiImage()),
        .init(name: "Hide Yo Kids Hide Yo Wi-Fi", image: .randomWiFiImage()),
        .init(name: "DLINK45892", image: .randomWiFiImage())
    ]
}

extension Image {
    /// For purposes of demonstration, generate a WiFi image with a random signal strength.
    static func randomWiFiImage() -> Image {
        Image(systemName: "wifi", variableValue: Double.random(in: 0.2 ... 1.0))
    }
}
