//
//  Image.swift
//  MacControlCenterSlider • https://github.com/orchetect/MacControlCenterSlider
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension Image {
    // MARK: Sound Slider Icon Stages
    
    public static let macControlCenterSoundSliderSpeakerOff: Self = {
        if #available(macOS 11, *) {
            return Image(systemName: "speaker.slash.fill")
        } else {
            let img = NSImage(named: NSImage.touchBarAudioOutputMuteTemplateName) ?? .init()
            return Image(nsImage: img)
        }
    }()
    
    public static let macControlCenterSoundSliderSpeakerVol1: Self = {
        if #available(macOS 11, *) {
            return Image(systemName: "speaker.wave.1.fill")
        } else {
            let img = NSImage(named: NSImage.touchBarAudioOutputVolumeLowTemplateName) ?? .init()
            return Image(nsImage: img)
        }
    }()
    
    public static let macControlCenterSoundSliderSpeakerVol2: Self = {
        if #available(macOS 11, *) {
            return Image(systemName: "speaker.wave.2.fill")
        } else {
            let img = NSImage(named: NSImage.touchBarAudioOutputVolumeMediumTemplateName) ?? .init()
            return Image(nsImage: img)
        }
    }()
    
    public static let macControlCenterSoundSliderSpeakerVol3: Self = {
        if #available(macOS 11, *) {
            return Image(systemName: "speaker.wave.3.fill")
        } else {
            let img = NSImage(named: NSImage.touchBarAudioOutputVolumeHighTemplateName) ?? .init()
            return Image(nsImage: img)
        }
    }()
    
    // MARK: Circle Button Images
    
    public static let macControlCenterCircleButtonSpeaker: Self = {
        if #available(macOS 11, *) {
            return Image(systemName: "speaker.wave.2.fill")
        } else {
            let img = NSImage(named: NSImage.touchBarAudioOutputVolumeMediumTemplateName) ?? .init()
            return Image(nsImage: img)
        }
    }()
}
