//
//  MenuModel.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import MacControlCenterUI
import MenuBarExtraAccess
import SwiftUI

@MainActor @Observable class MenuModel {
    var isMenuPresented: Bool = false

    var isEnabled = true

    var uuidContentItems: [UUID] = (0 ... 9).map { _ in UUID() }
    var isUUIDContentShown = false
    var isUUIDContentAnimated = true

    var darkMode: Bool = true
    var nightShift: Bool = true
    var trueTone: Bool = true

    var volume: CGFloat = 0.75
    var brightness: CGFloat = 0.5

    var audioOutputs: [MenuEntry] = MockData.audioOutputs
    var audioOutputSelection: MenuEntry.ID? = MockData.audioOutputsDefault
    var airPodsOptions: [MenuEntry] = MockData.airPodsOptions
    var airPodsOptionSelection: MenuEntry.ID? = MockData.airPodsOptionsDefault

    var isWiFiExpanded = true
    var wiFiNetworks: [MenuEntry] = MockData.wiFiNetworks
    var wiFiSelection: MenuEntry.ID? = MockData.wiFiNetworksDefault

    var isSafariEnabled: Bool = true
    var isMusicEnabled: Bool = true

    init() { }
}

// MARK: - ViewModel Properties/Methods

extension MenuModel {
    /// Appends 10 new random items to the UUID Content Items array.
    func addUUIDContentItems() {
        uuidContentItems.append(contentsOf: (0 ... 9).map { _ in UUID() })
    }

    /// Randomizes all model state.
    func randomizeState() {
        isEnabled = .random()

        addUUIDContentItems()
        // isUUIDContentShown = .random()
        // isUUIDContentAnimated = .random()

        darkMode = .random()
        nightShift = .random()
        trueTone = .random()

        volume = .random(in: 0.0 ... 1.0)
        brightness = .random(in: 0.0 ... 1.0)

        audioOutputs = MockData.audioOutputs.filter { _ in Bool.random() }.shuffled()
        audioOutputSelection = audioOutputs.randomElement()?.id
        airPodsOptionSelection = airPodsOptions.randomElement()?.id

        isWiFiExpanded = .random()
        wiFiNetworks = MockData.wiFiNetworks.filter { _ in Bool.random() }.shuffled()
        wiFiSelection = wiFiNetworks.randomElement()?.id

        isSafariEnabled = .random()
        isMusicEnabled = .random()
    }
}
