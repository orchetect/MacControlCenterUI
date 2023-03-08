//
//  MenuCircleToggle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// macOS Control Center-style circle toggle control.
/// For the momentary button variant, use ``MenuCircleButton`.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuCircleToggle<Label: View>: View {
    // MARK: Public Properties
    
    @Binding public var isOn: Bool
    public var style: MenuCircleButtonStyle
    public var label: Label?
    public var onClickBlock: (Bool) -> Void
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: Private State
    
    @State private var isMouseDown: Bool = false
    private var controlSize: MenuCircleButtonSize
    
    // MARK: Init - No Label
    
    public init(
        isOn: Binding<Bool>,
        controlSize: MenuCircleButtonSize = .menu,
        style: MenuCircleButtonStyle,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == EmptyView {
        self._isOn = isOn
        self.controlSize = controlSize
        self.style = style
        self.label = nil
        self.onClickBlock = onClickBlock
    }
    
    public init(
        isOn: Binding<Bool>,
        controlSize: MenuCircleButtonSize = .menu,
        image: Image,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == EmptyView {
        self._isOn = isOn
        self.controlSize = controlSize
        self.style = .init(image: image)
        self.label = nil
        self.onClickBlock = onClickBlock
    }
    
    // MARK: Init - With String Label
    
    public init<S>(
        _ title: S,
        isOn: Binding<Bool>,
        controlSize: MenuCircleButtonSize = .menu,
        style: MenuCircleButtonStyle,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where S: StringProtocol, Label == Text {
        self.label = Text(title)
        self._isOn = isOn
        self.controlSize = controlSize
        self.style = style
        self.onClickBlock = onClickBlock
    }
    
    public init<S>(
        _ title: S,
        isOn: Binding<Bool>,
        controlSize: MenuCircleButtonSize = .menu,
        image: Image,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where S: StringProtocol, Label == Text {
        self.label = Text(title)
        self._isOn = isOn
        self.controlSize = controlSize
        self.style = .init(image: image)
        self.onClickBlock = onClickBlock
    }
    
    // MARK: Init - With LocalizedStringKey Label
    
    public init(
        _ titleKey: LocalizedStringKey,
        isOn: Binding<Bool>,
        controlSize: MenuCircleButtonSize = .menu,
        style: MenuCircleButtonStyle,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == Text {
        self.label = Text(titleKey)
        self._isOn = isOn
        self.controlSize = controlSize
        self.style = style
        self.onClickBlock = onClickBlock
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        isOn: Binding<Bool>,
        controlSize: MenuCircleButtonSize = .menu,
        image: Image,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == Text {
        self.label = Text(titleKey)
        self._isOn = isOn
        self.controlSize = controlSize
        self.style = .init(image: image)
        self.onClickBlock = onClickBlock
    }
    
    // MARK: Init - With Label Closure
    
    public init(
        isOn: Binding<Bool>,
        controlSize: MenuCircleButtonSize = .menu,
        style: MenuCircleButtonStyle,
        @ViewBuilder label: @escaping () -> Label,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.controlSize = controlSize
        self.style = style
        self.label = label()
        self.onClickBlock = onClickBlock
    }
    
    public init(
        isOn: Binding<Bool>,
        controlSize: MenuCircleButtonSize = .menu,
        image: Image,
        @ViewBuilder label: @escaping () -> Label,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.controlSize = controlSize
        self.style = .init(image: image)
        self.label = label()
        self.onClickBlock = onClickBlock
    }
    
    // MARK: Init - With Label
    
    @_disfavoredOverload
    public init(
        isOn: Binding<Bool>,
        controlSize: MenuCircleButtonSize = .menu,
        style: MenuCircleButtonStyle,
        label: Label,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.controlSize = controlSize
        self.style = style
        self.label = label
        self.onClickBlock = onClickBlock
    }
    
    @_disfavoredOverload
    public init(
        isOn: Binding<Bool>,
        controlSize: MenuCircleButtonSize = .menu,
        image: Image,
        label: Label,
        onClick onClickBlock: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.controlSize = controlSize
        self.style = .init(image: image)
        self.label = label
        self.onClickBlock = onClickBlock
    }
    
    // MARK: Body
    
    public var body: some View {
        switch controlSize {
        case .menu:
            if label != nil {
                hitTestBody
                    .frame(height: controlSize.size)
                    .frame(maxWidth: .infinity)
            } else {
                hitTestBody
                    .frame(width: controlSize.size, height: controlSize.size)
            }
        case .prominent:
            if label != nil {
                hitTestBody
                    .frame(minHeight: controlSize.size + 26,
                           alignment: .top)
            } else {
                hitTestBody
                    .frame( //width: style.size,
                        height: controlSize.size,
                        alignment: .top)
            }
        }
    }
    
    @ViewBuilder
    private var hitTestBody: some View {
        GeometryReader { geometry in
            buttonBody
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let hit = geometry.frame(in: .local).contains(value.location)
                            isMouseDown = hit
                        }
                        .onEnded { value in
                            defer { isMouseDown = false }
                            if isMouseDown {
                                isOn.toggle()
                                onClickBlock(isOn)
                            }
                        }
                )
        }
    }
    
    @ViewBuilder
    private var buttonBody: some View {
        if let label = label {
            switch controlSize {
            case .menu:
                HStack {
                    circleBody
                    label.frame(maxWidth: .infinity, alignment: .leading)
                }
            case .prominent:
                VStack(alignment: .center, spacing: 4) {
                    circleBody
                    label
                }
                .fixedSize()
            }
        } else {
            circleBody
        }
    }
    
    @ViewBuilder
    private var circleBody: some View {
        ZStack {
            if style.hasColor {
                Circle()
                    .background(visualEffect)
                    .foregroundColor(buttonBackColor)
            }
            if let image = style.image(forState: isOn) {
                image
                    .resizable()
                    .scaledToFit()
                    .padding(controlSize.imagePadding + style.imagePadding)
                    .foregroundColor(buttonForeColor)
            }
            
            if isMouseDown, style.hasColor {
                if colorScheme == .dark {
                    Circle()
                        .foregroundColor(.white)
                        .opacity(0.1)
                } else {
                    Circle()
                        .foregroundColor(.black)
                        .opacity(0.1)
                }
            }
        }
        .frame(width: controlSize.size, height: controlSize.size)
    }
    
    // MARK: Helpers
    
    private var visualEffect: VisualEffect? {
        guard !isOn else { return nil }
        if colorScheme == .dark {
            return VisualEffect(
                .hudWindow,
                vibrancy: false,
                blendingMode: .withinWindow,
                mask: mask()
            )
        } else {
            return VisualEffect(
                .underWindowBackground,
                vibrancy: true,
                blendingMode: .behindWindow,
                mask: mask()
            )
        }
    }
    
    private func mask() -> NSImage?  {
        NSImage(
            color: .black,
            ovalSize: .init(width: controlSize.size, height: controlSize.size)
        )
    }
    
    private var buttonBackColor: Color? {
        style.color(forState: isOn, colorScheme: colorScheme)
    }
    
    private var buttonForeColor: Color {
        switch isOn {
        case true:
            switch colorScheme {
            case .dark:
                return style.invertForeground
                    ? Color(NSColor.textBackgroundColor)
                    : Color(NSColor.textColor)
            case .light:
                return style.invertForeground
                    ? Color(NSColor.textColor)
                    : Color(NSColor.textBackgroundColor)
            @unknown default:
                return Color(NSColor.textColor)
            }
        case false:
            switch colorScheme {
            case .dark:
                return Color(white: 0.85)
            case .light:
                return .black
            @unknown default:
                return Color(NSColor.selectedMenuItemTextColor)
            }
        }
    }
}
