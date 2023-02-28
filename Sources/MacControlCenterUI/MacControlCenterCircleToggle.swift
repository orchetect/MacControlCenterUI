//
//  MacControlCenterCircleToggle.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MacControlCenterCircleToggle<Label: View>: View {
    // MARK: Public Properties
    
    @Binding public var isOn: Bool
    public var image: Image
    public var color: Color
    public var invertForeground: Bool
    public var label: Label?
    public var onChangeBlock: (Bool) -> Void
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: Private State
    
    @State private var isMouseDown: Bool = false
    private var style: ButtonStyle
    
    public enum ButtonStyle {
        /// Standard Control Center Menu item size with trailing label.
        case menu
        
        /// Prominent size with bottom edge label.
        case prominent
        
        var size: CGFloat {
            switch self {
            case .menu: return 26
            case .prominent: return 38
            }
        }
        
        var imagePadding: CGFloat {
            switch self {
            case .menu: return 5
            case .prominent: return 10
            }
        }
    }
    
    // MARK: Init
    
    public init(
        isOn: Binding<Bool>,
        style: ButtonStyle = .menu,
        color: Color = Color(NSColor.controlAccentColor),
        invertForeground: Bool = false,
        image: Image,
        onChange onChangeBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == EmptyView {
        self._isOn = isOn
        self.style = style
        self.color = color
        self.invertForeground = invertForeground
        self.image = image
        self.label = nil
        self.onChangeBlock = onChangeBlock
    }
    
    public init<S>(
        _ title: S,
        isOn: Binding<Bool>,
        style: ButtonStyle = .menu,
        color: Color = Color(NSColor.controlAccentColor),
        invertForeground: Bool = false,
        image: Image,
        @ViewBuilder label: @escaping () -> Label,
        onChange onChangeBlock: @escaping (Bool) -> Void = { _ in }
    ) where S: StringProtocol, Label == Text {
        self.init(
            isOn: isOn,
            style: style,
            color: color,
            invertForeground: invertForeground,
            image: image,
            label: { Text(title) },
            onChange: onChangeBlock
        )
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        isOn: Binding<Bool>,
        style: ButtonStyle = .menu,
        color: Color = Color(NSColor.controlAccentColor),
        invertForeground: Bool = false,
        image: Image,
        onChange onChangeBlock: @escaping (Bool) -> Void = { _ in }
    ) where Label == Text {
        self.init(
            isOn: isOn,
            style: style,
            color: color,
            invertForeground: invertForeground,
            image: image,
            label: { Text(titleKey) },
            onChange: onChangeBlock
        )
    }
    
    public init(
        isOn: Binding<Bool>,
        style: ButtonStyle = .menu,
        color: Color = Color(NSColor.controlAccentColor),
        invertForeground: Bool = false,
        image: Image,
        @ViewBuilder label: @escaping () -> Label,
        onChange onChangeBlock: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.style = style
        self.color = color
        self.invertForeground = invertForeground
        self.image = image
        self.label = label()
        self.onChangeBlock = onChangeBlock
    }
    
    // MARK: Body
    
    public var body: some View {
        switch style {
        case .menu:
            if label != nil {
                hitTestBody
                    .frame(height: style.size)
                    .frame(maxWidth: .infinity)
            } else {
                hitTestBody
                    .frame(width: style.size, height: style.size)
            }
        case .prominent:
            if label != nil {
                hitTestBody
                    .frame(minHeight: style.size + 26,
                           alignment: .top)
            } else {
                hitTestBody
                    .frame( //width: style.size,
                        height: style.size,
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
                                onChangeBlock(isOn)
                            }
                        }
                )
        }
    }
    
    @ViewBuilder
    private var buttonBody: some View {
        if let label = label {
            switch style {
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
            Circle()
                .background(visualEffect)
                .foregroundColor(buttonBackColor)
            image
                .resizable()
                .scaledToFit()
                .padding(style.imagePadding)
                .foregroundColor(buttonForeColor)
            
            if isMouseDown {
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
        .frame(width: style.size, height: style.size)
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
            ovalSize: .init(width: style.size, height: style.size)
        )
    }
    
    private var buttonBackColor: Color {
        switch isOn {
        case true:
            return color
        case false:
            switch colorScheme {
            case .dark:
                return Color(NSColor.controlColor) //.opacity(0.8)
            case .light:
                return Color(white: 1).opacity(0.2)
            @unknown default:
                return Color(NSColor.controlColor) //.opacity(0.8)
            }
        }
    }
    
    private var buttonForeColor: Color {
        switch isOn {
        case true:
            switch colorScheme {
            case .dark:
                return invertForeground
                ? Color(NSColor.textBackgroundColor)
                : Color(NSColor.textColor)
            case .light:
                return invertForeground
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
