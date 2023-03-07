//
//  MenuToggle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

/// ``MacControlCenterMenu`` menu item with a toggle state.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuToggle<Label: View>: View, MacControlCenterMenuItem {
    @Binding public var isOn: Bool
    public var image: Image?
    public var color: Color
    public var offColor: Color?
    public var invertForeground: Bool
    public var label: Label?
    public var onChangeBlock: (Bool) -> Void
    
    // MARK: Init - No Label
    
    public init(
        isOn: Binding<Bool>,
        color: Color = Color(NSColor.controlAccentColor),
        offColor: Color? = nil,
        invertForeground: Bool = false,
        image: Image? = nil,
        onChange onChangeBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == EmptyView {
        self._isOn = isOn
        self.color = color
        self.offColor = offColor
        self.invertForeground = invertForeground
        self.image = image
        self.label = nil
        self.onChangeBlock = onChangeBlock
    }
    
    // MARK: Init - With String Label
    
    public init<S>(
        _ title: S,
        isOn: Binding<Bool>,
        color: Color = Color(NSColor.controlAccentColor),
        offColor: Color? = nil,
        invertForeground: Bool = false,
        image: Image? = nil,
        onChange onChangeBlock: @escaping (Bool) -> Void = { _ in }
    ) where S: StringProtocol, Label == Text {
        self.label = Text(title)
        self._isOn = isOn
        self.color = color
        self.offColor = offColor
        self.invertForeground = invertForeground
        self.image = image
        self.onChangeBlock = onChangeBlock
    }
    
    // MARK: Init - With LocalizedStringKey Label
    
    public init(
        _ titleKey: LocalizedStringKey,
        isOn: Binding<Bool>,
        color: Color = Color(NSColor.controlAccentColor),
        offColor: Color? = nil,
        invertForeground: Bool = false,
        image: Image? = nil,
        onChange onChangeBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == Text {
        self.label = Text(titleKey)
        self._isOn = isOn
        self.color = color
        self.offColor = offColor
        self.invertForeground = invertForeground
        self.image = image
        self.onChangeBlock = onChangeBlock
    }
    
    // MARK: Init - With Label Closure
    
    public init(
        isOn: Binding<Bool>,
        color: Color = Color(NSColor.controlAccentColor),
        offColor: Color? = nil,
        invertForeground: Bool = false,
        image: Image? = nil,
        @ViewBuilder label: @escaping () -> Label,
        onChange onChangeBlock: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.color = color
        self.offColor = offColor
        self.invertForeground = invertForeground
        self.image = image
        self.label = label()
        self.onChangeBlock = onChangeBlock
    }
    
    // MARK: Init - With Label
    
    @_disfavoredOverload
    public init(
        isOn: Binding<Bool>,
        color: Color = Color(NSColor.controlAccentColor),
        offColor: Color? = nil,
        invertForeground: Bool = false,
        image: Image? = nil,
        label: Label,
        onChange onChangeBlock: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.color = color
        self.offColor = offColor
        self.invertForeground = invertForeground
        self.image = image
        self.label = label
        self.onChangeBlock = onChangeBlock
    }
    
    // MARK: Body
    
    public var body: some View {
        HighlightingMenuItem(height: .controlCenterIconItem) {
            MacControlCenterCircleToggle(
                isOn: $isOn,
                style: .menu,
                color: color,
                offColor: offColor,
                invertForeground: invertForeground,
                label: {
                    label
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                },
                onChange: onChangeBlock
            )
        }
    }
}
