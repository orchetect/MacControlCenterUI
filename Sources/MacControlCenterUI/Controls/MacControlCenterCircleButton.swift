//
//  MacControlCenterCircleButton.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// macOS Control Center-style circle toggle button.
/// For the dual state toggle variant, use ``MacControlCenterCircleToggle``.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MacControlCenterCircleButton<Label: View>: View {
    // MARK: Public Properties
    
    public var controlSize: MacControlCenterCircleButtonSize
    public var style: MacControlCenterCircleButtonStyle
    public var label: Label?
    public var actionBlock: () -> Void
    
    // MARK: Private State
    
    @State private var isMouseDown: Bool = false
    
    // MARK: Init
    
    public init(
        controlSize: MacControlCenterCircleButtonSize = .menu,
        style: MacControlCenterCircleButtonStyle,
        action actionBlock: @escaping () -> Void
    ) where Label == EmptyView {
        self.controlSize = controlSize
        self.style = style
        self.label = nil
        self.actionBlock = actionBlock
    }
    
    public init<S>(
        _ title: S,
        controlSize: MacControlCenterCircleButtonSize = .menu,
        style: MacControlCenterCircleButtonStyle,
        @ViewBuilder label: @escaping () -> Label,
        action actionBlock: @escaping () -> Void
    ) where S: StringProtocol, Label == Text {
        self.init(
            controlSize: controlSize,
            style: style,
            label: { Text(title) },
            action: actionBlock
        )
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        controlSize: MacControlCenterCircleButtonSize = .menu,
        style: MacControlCenterCircleButtonStyle,
        action actionBlock: @escaping () -> Void
    ) where Label == Text {
        self.init(
            controlSize: controlSize,
            style: style,
            label: { Text(titleKey) },
            action: actionBlock
        )
    }
    
    public init(
        controlSize: MacControlCenterCircleButtonSize = .menu,
        style: MacControlCenterCircleButtonStyle,
        @ViewBuilder label: @escaping () -> Label,
        action actionBlock: @escaping () -> Void
    ) {
        self.controlSize = controlSize
        self.style = style
        self.label = label()
        self.actionBlock = actionBlock
    }
    
    // MARK: Body
    
    public var body: some View {
        MacControlCenterCircleToggle(
            isOn: .constant(false),
            controlSize: controlSize,
            style: style,
            label: label
        ) { _ in
            actionBlock()
        }
    }
}
