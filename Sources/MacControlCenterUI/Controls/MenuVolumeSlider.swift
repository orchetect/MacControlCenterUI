//
//  MenuVolumeSlider.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuVolumeSlider<Label: View>: View {
    @Binding public var value: CGFloat
    public var label: Label?
    
    // MARK: Init
    
    public init(
        value: Binding<CGFloat>
    ) where Label == EmptyView {
        _value = value
    }
    
    public init<S>(
        _ label: S,
        value: Binding<CGFloat>
    ) where S: StringProtocol, Label == Text {
        _value = value
        self.label = Text(label)
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        value: Binding<CGFloat>
    ) where Label == Text {
        _value = value
        self.label = Text(titleKey)
    }
    
    public init(
        value: Binding<CGFloat>,
        label: () -> Label
    ) {
        _value = value
        self.label = label()
    }
    
    // MARK: Body
    
    public var body: some View {
        if let label = label {
            MenuSlider(
                value: $value,
                label: { label },
                image: VolumeSliderIcon()
            )
        } else {
            MenuSlider(
                value: $value,
                image: VolumeSliderIcon()
            )
        }
    }
}

// MARK: - Custom MenuSliderImage

extension MenuVolumeSlider {
    private struct VolumeSliderIcon: MenuSliderImage {
        func image(
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
        
        func transform(image: Image, for value: CGFloat) -> AnyView? {
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
                case .off: return .speakerOff
                case .vol1: return .speakerVol1
                case .vol2: return .speakerVol2
                case .vol3: return .speakerVol3
                }
            }
        }
    }
}

// MARK: - Sound Slider Icon Stages

extension Image {
    fileprivate static let speakerOff: Self = Image(systemName: "speaker.slash.fill")
    fileprivate static let speakerVol1: Self = Image(systemName: "speaker.wave.1.fill")
    fileprivate static let speakerVol2: Self = Image(systemName: "speaker.wave.2.fill")
    fileprivate static let speakerVol3: Self = Image(systemName: "speaker.wave.3.fill")
}
