//
//  VolumeMenuSliderImage.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// A ``MenuSliderImage`` suitable for a volume slider.
nonisolated
public struct VolumeMenuSliderImage {
    public init() { }
}

extension VolumeMenuSliderImage: MenuSliderImage {
    public func image(forValue value: CGFloat, style: MenuSliderStyle) -> MenuSliderImageDescriptor? {
        guard let level = Level(value: value) else { return nil }
        
        return MenuSliderImageDescriptor(
            image: level.image,
            scale: level.scale(for: style),
            xOffset: level.xOffset(for: style)
        )
    }
    
    public func deltaImage(forValue value: CGFloat, oldValue: CGFloat?, style: MenuSliderStyle, force: Bool) -> MenuSliderImageUpdate? {
        for level in Level.allCases {
            if isNewlyEntered(value: value, oldValue: oldValue, in: level.range, force: force) {
                let imageDescriptor = MenuSliderImageDescriptor(
                    image: level.image,
                    scale: level.scale(for: style),
                    xOffset: level.xOffset(for: style)
                )
                return .newImage(imageDescriptor)
            }
        }
        
        return .noChange
    }
    
    public func minImage(style: MenuSliderStyle) -> MenuSliderImageDescriptor? {
        image(forValue: 0.01, style: style)
    }
    
    public func maxImage(style: MenuSliderStyle) -> MenuSliderImageDescriptor? {
        image(forValue: 1.0, style: style)
    }
}

extension VolumeMenuSliderImage {
    private enum Level: CaseIterable {
        case off // "muted"
        case vol0 // "min"
        case vol1
        case vol2
        case vol3 // "max"
        
        init?(value: CGFloat) {
            switch value {
            case Self.off.range: self = .off
            case Self.vol0.range: self = .vol0
            case Self.vol1.range: self = .vol1
            case Self.vol2.range: self = .vol2
            case Self.vol3.range: self = .vol3
            default: return nil
            }
        }
        
        var range: ClosedRange<CGFloat> {
            switch self {
            case .off: return 0.0 ... 0.0
            case .vol0: return 0.00001 ... 0.165
            case .vol1: return 0.165 ... 0.33
            case .vol2: return 0.33 ... 0.66
            case .vol3: return 0.66 ... 1.0
            }
        }
        
        var image: Image {
            switch self {
            case .off: return Image(systemName: "speaker.slash.fill")
            case .vol0: return Image(systemName: "speaker.fill")
            case .vol1: return Image(systemName: "speaker.wave.1.fill")
            case .vol2: return Image(systemName: "speaker.wave.2.fill")
            case .vol3: return Image(systemName: "speaker.wave.3.fill")
            }
        }
        
        func xOffset(for style: MenuSliderStyle) -> CGFloat? {
            nil
        }
        
        func scale(for style: MenuSliderStyle) -> CGFloat? {
            nil
        }
    }
}

// MARK: - Static Constructor

extension MenuSliderImage where Self == VolumeMenuSliderImage {
    /// A ``MenuSliderImage`` suitable for a volume slider.
    public static var volume: VolumeMenuSliderImage { VolumeMenuSliderImage() }
}

#if DEBUG
@available(macOS 14.0, *)
#Preview("Current Platform") {
    @Previewable @State var value: CGFloat = 0.5
    
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuSlider("Volume", value: $value, image: .volume)
    }
}

@available(macOS 26.0, *)
#Preview("macOS 26 Style") {
    @Previewable @State var value: CGFloat = 0.5
    
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuSlider<Text, VolumeMenuSliderImage>
            .MacOS26MenuSlider(value: $value, label: Text("Volume"), image: .volume)
    }
}

@available(macOS 14.0, *)
#Preview("macOS 10.15-15.0 Style") {
    @Previewable @State var value: CGFloat = 0.5
    
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuSlider<Text, VolumeMenuSliderImage>
            .MacOS10_15Thru15MenuSlider(value: $value, label: Text("Volume"), image: .volume)
    }
}

#endif

#endif
