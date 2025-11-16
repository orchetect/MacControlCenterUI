//
//  VolumeMenuSliderImage.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// A ``MenuSliderImage`` suitable for a volume slider.
nonisolated
public struct VolumeMenuSliderImage: MenuSliderImage {
    public func image(
        for value: CGFloat,
        oldValue: CGFloat?,
        force: Bool = false
    ) -> MenuSliderImageUpdate? {
        if newlyEntered(value: value, oldValue: oldValue, in: Level.off.range, force: force) {
            return .newImage(Level.off.image)
        }
        
        if newlyEntered(value: value, oldValue: oldValue, in: Level.vol1.range, force: force) {
            return .newImage(Level.vol1.image)
        }
        
        if newlyEntered(value: value, oldValue: oldValue, in: Level.vol2.range, force: force) {
            return .newImage(Level.vol2.image)
        }
        
        if newlyEntered(value: value, oldValue: oldValue, in: Level.vol3.range, force: force) {
            return .newImage(Level.vol3.image)
        }
        
        return .noChange
    }
    
    public func transform(image: Image, for value: CGFloat) -> AnyView? {
        let level = Level(value: value)
        
        let img = image
            .resizable()
            .scaledToFit()
            .frame(width: level?.width ?? 22, height: 22)
        
        if level?.shouldCenter ?? false {
            return AnyView(
                img
                    .frame(width: 22, alignment: .center)
            )
        } else {
            return AnyView(
                img
                    .offset(x: 4, y: 0)
            )
        }
    }
}

extension VolumeMenuSliderImage {
    private enum Level {
        case off
        case vol1
        case vol2
        case vol3
        
        init?(value: CGFloat) {
            switch value {
            case Self.off.range: self = .off
            case Self.vol1.range: self = .vol1
            case Self.vol2.range: self = .vol2
            case Self.vol3.range: self = .vol3
            default: return nil
            }
        }
        
        var range: ClosedRange<CGFloat> {
            switch self {
            case .off: return 0.0 ... 0.0
            case .vol1: return 0.00001 ... 0.33
            case .vol2: return 0.33 ... 0.66
            case .vol3: return 0.66 ... 1.0
            }
        }
        
        var width: CGFloat {
            if #available(macOS 11, *) {
                switch self {
                case .off: return 10
                case .vol1: return 9
                case .vol2: return 11
                case .vol3: return 14
                }
            } else {
                return 22
            }
        }
        
        var shouldCenter: Bool {
            if #available(macOS 11, *) {
                switch self {
                case .off: return true
                case .vol1, .vol2, .vol3: return false
                }
            } else {
                return false
            }
        }
        
        var image: Image {
            switch self {
            case .off: return Image(systemName: "speaker.slash.fill")
            case .vol1: return Image(systemName: "speaker.wave.1.fill")
            case .vol2: return Image(systemName: "speaker.wave.2.fill")
            case .vol3: return Image(systemName: "speaker.wave.3.fill")
            }
        }
    }
}

#endif
