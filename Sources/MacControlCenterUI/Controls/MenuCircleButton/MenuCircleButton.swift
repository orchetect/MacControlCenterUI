//
//  MenuCircleButton.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// macOS Control Center-style circle toggle button.
/// For the dual state toggle variant, use ``MenuCircleToggle``.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuCircleButton<Label: View>: View {
    // MARK: Public Properties
    
    public var controlSize: MenuCircleButtonSize
    public var style: MenuCircleButtonStyle
    public var label: Label?
    public var actionBlock: () -> Void
    
    // MARK: Private State
    
    @State private var isMouseDown: Bool = false
    
    // MARK: Init - No Label
    
    public init(
        controlSize: MenuCircleButtonSize = .menu,
        style: MenuCircleButtonStyle,
        action actionBlock: @escaping () -> Void
    ) where Label == EmptyView {
        self.controlSize = controlSize
        self.style = style
        label = nil
        self.actionBlock = actionBlock
    }
    
    // MARK: Init - With String Label
    
    @_disfavoredOverload
    public init<S>(
        _ title: S,
        controlSize: MenuCircleButtonSize = .menu,
        style: MenuCircleButtonStyle,
        action actionBlock: @escaping () -> Void
    ) where S: StringProtocol, Label == Text {
        self.init(
            controlSize: controlSize,
            style: style,
            action: actionBlock,
            label: { Text(title) }
        )
    }
    
    // MARK: Init - With LocalizedStringKey Label
    
    public init(
        _ titleKey: LocalizedStringKey,
        controlSize: MenuCircleButtonSize = .menu,
        style: MenuCircleButtonStyle,
        action actionBlock: @escaping () -> Void
    ) where Label == Text {
        self.init(
            controlSize: controlSize,
            style: style,
            action: actionBlock,
            label: { Text(titleKey) }
        )
    }
    
    // MARK: Init - With LocalizedStringResource Label
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource,
        controlSize: MenuCircleButtonSize = .menu,
        style: MenuCircleButtonStyle,
        action actionBlock: @escaping () -> Void
    ) where Label == Text {
        self.init(
            controlSize: controlSize,
            style: style,
            action: actionBlock,
            label: { Text(titleResource) }
        )
    }
    
    // MARK: Init - With Label Closure
    
    public init(
        controlSize: MenuCircleButtonSize = .menu,
        style: MenuCircleButtonStyle,
        action actionBlock: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.controlSize = controlSize
        self.style = style
        self.actionBlock = actionBlock
        self.label = label()
    }
    
    // MARK: Body
    
    public var body: some View {
        MenuCircleToggle(
            isOn: .constant(false),
            controlSize: controlSize,
            style: style,
            label: label
        ) { _ in
            actionBlock()
        }
    }
}

#endif
