//
//  MenuVolumeSlider.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

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
    
    @_disfavoredOverload
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
        label = Text(titleKey)
    }
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource,
        value: Binding<CGFloat>
    ) where Label == Text {
        _value = value
        label = Text(titleResource)
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
                image: VolumeMenuSliderImage()
            )
        } else {
            MenuSlider(
                value: $value,
                image: VolumeMenuSliderImage()
            )
        }
    }
}

#endif
