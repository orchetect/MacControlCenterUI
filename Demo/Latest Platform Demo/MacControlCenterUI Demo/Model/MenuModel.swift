//
//  MenuModel.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

struct MenuModel {
    var darkMode: Bool = true
    var nightShift: Bool = true
    var trueTone: Bool = true
    
    var volume: CGFloat = 0.75
    var brightness: CGFloat = 0.5
    
    var audioOutputSelection: MenuEntry.ID? = MockData.audioOutputsDefault
    
    var airPodsOptionSelection: MenuEntry.ID? = MockData.airPodsOptionsDefault
    
    var isWiFiExpanded = true
    var wiFiSelection: MenuEntry.ID? = MockData.wiFiNetworksDefault
    
    var audioOutputs: [MenuEntry] = MockData.audioOutputs
    var airPodsOptions: [MenuEntry] = MockData.airPodsOptions
    var wiFiNetworks: [MenuEntry] = MockData.wiFiNetworks
}

extension MenuModel {
    /// Based on macOS Control Center slider width
    static let sliderWidth: CGFloat = 270
}
