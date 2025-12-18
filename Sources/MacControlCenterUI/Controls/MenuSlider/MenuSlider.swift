//
//  MenuSlider.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuSlider<Label, SliderImage>: View
where Label: View, SliderImage: MenuSliderImage {
    // MARK: Public Properties
    
    /// Value (0.0 ... 1.0).
    @Binding public var value: CGFloat
    
    public var label: Label?
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: Private State
    
    @State private var oldValue: CGFloat? = nil
    @State private var currentImage: Image? = nil
    @State private var currentImageView: AnyView? = nil
    private let sliderImage: SliderImage?
    
    /// Slider height.
    /// This value is fixed to mirror that of macOS's Control Center.
    /// These sliders are never found at variable heights. They can be any width however.
    private static var sliderHeight: CGFloat { 22 }
    
    // MARK: Init - Image
    
    public init(
        value: Binding<CGFloat>,
        image: @autoclosure () -> Image
    ) where Label == EmptyView, SliderImage == StaticSliderImage {
        _value = value
        sliderImage = StaticSliderImage(image())
    }
    
    @_disfavoredOverload
    public init<S>(
        _ label: S,
        value: Binding<CGFloat>,
        image: @autoclosure () -> Image
    ) where S: StringProtocol, Label == Text, SliderImage == StaticSliderImage {
        _value = value
        self.label = Text(label)
        sliderImage = StaticSliderImage(image())
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        value: Binding<CGFloat>,
        image: @autoclosure () -> Image
    ) where Label == Text, SliderImage == StaticSliderImage {
        _value = value
        label = Text(titleKey)
        sliderImage = StaticSliderImage(image())
    }
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource,
        value: Binding<CGFloat>,
        image: @autoclosure () -> Image
    ) where Label == Text, SliderImage == StaticSliderImage {
        _value = value
        label = Text(titleResource)
        sliderImage = StaticSliderImage(image())
    }
    
    public init(
        value: Binding<CGFloat>,
        label: () -> Label,
        image: @autoclosure () -> Image
    ) where SliderImage == StaticSliderImage {
        _value = value
        self.label = label()
        sliderImage = StaticSliderImage(image())
    }
    
    // MARK: Init - SliderImage
    
    @_disfavoredOverload
    public init(
        value: Binding<CGFloat>,
        image: @autoclosure () -> SliderImage
    ) where Label == EmptyView {
        _value = value
        sliderImage = image()
    }
    
    @_disfavoredOverload
    public init<S>(
        _ label: S,
        value: Binding<CGFloat>,
        image: @autoclosure () -> SliderImage
    ) where S: StringProtocol, Label == Text {
        _value = value
        self.label = Text(label)
        sliderImage = image()
    }
    
    @_disfavoredOverload
    public init(
        _ titleKey: LocalizedStringKey,
        value: Binding<CGFloat>,
        image: @autoclosure () -> SliderImage
    ) where Label == Text {
        _value = value
        label = Text(titleKey)
        sliderImage = image()
    }
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(
        _ titleResource: LocalizedStringResource,
        value: Binding<CGFloat>,
        image: @autoclosure () -> SliderImage
    ) where Label == Text {
        _value = value
        label = Text(titleResource)
        sliderImage = image()
    }
    
    @_disfavoredOverload
    public init(
        value: Binding<CGFloat>,
        label: () -> Label,
        image: @autoclosure () -> SliderImage
    ) {
        _value = value
        self.label = label()
        sliderImage = image()
    }
    
    // MARK: Body
    
    public var body: some View {
        sliderView
            .geometryGroupIfSupportedByPlatform()
            .onAppear {
                // validate value
                value = value.clamped(to: 0.0 ... 1.0)
            }
    }
    
    @ViewBuilder
    private var sliderView: some View {
        if #available(macOS 26, *) {
            MacOS26MenuSlider(value: $value, label: label, image: sliderImage)
        } else {
            MacOS10_15Thru15MenuSlider(value: $value, label: label, image: sliderImage)
        }
    }
}

extension MenuSlider {
    /// Slider design used in macOS 26 (Tahoe) and later.
    @available(macOS 26.0, *)
    struct MacOS26MenuSlider: View {
        // MARK: Public Properties
        
        /// Value (0.0 ... 1.0).
        @Binding private var value: CGFloat
        private var label: Label?
        private let sliderImage: SliderImage?
        
        // MARK: Private State
        
        @State private var minImage: AnyView? = nil
        @State private var maxImage: AnyView? = nil
        
        /// Slider height.
        /// This value is fixed to mirror that of macOS's Control Center.
        /// These sliders are never found at variable heights. They can be any width however.
        private static var sliderHeight: CGFloat { 22 }
        
        // MARK: Init - Image
        
        init(value: Binding<CGFloat>, label: Label? = nil, image: SliderImage? = nil) {
            _value = value
            self.label = label
            self.sliderImage = image
        }
        
        // MARK: Body
        
        var body: some View {
            VStack(spacing: 8) {
                if let label = label {
                    HStack {
                        label
                            .font(.system(size: MenuStyling.headerFontSize, weight: .bold))
                        Spacer()
                    }
                }
                sliderBody
            }
        }
        
        @ViewBuilder
        var sliderBody: some View {
            Slider<EmptyView, AnyView?>(
                value: $value,
                in: 0.0 ... 1.0,
                minimumValueLabel: minImage,
                maximumValueLabel: maxImage,
                label: { EmptyView() /* label */ }
            )
            .labelsHidden()
            .controlSize(.small)
            .frame(height: Self.sliderHeight)
            .geometryGroupIfSupportedByPlatform()
            .onChange(of: value) { oldValue, newValue in
                updateImage(fgColor: .secondary, oldValue: oldValue)
            }
            .onAppear {
                updateImage(fgColor: .secondary, force: true)
            }
        }
        
        private func updateImage(fgColor: Color, oldValue: CGFloat? = nil, force: Bool = false) {
            guard let sliderImage = sliderImage else { return }
            
            // first check if static image is being used
            if minImage == nil || force,
                let imageDescriptor = sliderImage.staticImage(style: .macOS26)
            {
                minImage = formatImage(sliderImage: sliderImage, imageDescriptor: imageDescriptor, fgColor: fgColor)
                maxImage = nil
                return
            }
            // otherwise check if a variable image is being used
            else {
                if value == 0.0 || oldValue == 0.0 || force,
                   let result = sliderImage.deltaImage(forValue: min(value, 0.001), oldValue: oldValue, style: .macOS26, force: force)
                {
                    switch result {
                    case let .newImage(imageDescriptor):
                        minImage = formatImage(sliderImage: sliderImage, imageDescriptor: imageDescriptor, fgColor: fgColor)
                    case .noChange:
                        return
                    }
                }
                if value == 1.0 || oldValue == 1.0 || force,
                   let result = sliderImage.deltaImage(forValue: max(value, 0.999), oldValue: oldValue, style: .macOS26, force: force)
                {
                    switch result {
                    case let .newImage(imageDescriptor):
                        maxImage = formatImage(sliderImage: sliderImage, imageDescriptor: imageDescriptor, fgColor: fgColor)
                    case .noChange:
                        return
                    }
                }
            }
        }
        
        private func formatImage(sliderImage: SliderImage, imageDescriptor: MenuSliderImageDescriptor, fgColor: Color) -> AnyView {
            return AnyView(
                imageDescriptor.image
                    .resizable()
                    .scaledToFit()
                    .frame(height: Self.sliderHeight - 6) // add a little padding
                    .frame(minWidth: Self.sliderHeight - 6) // add a little padding
                    .scaleEffect(imageDescriptor.scale ?? 1.0, anchor: .center)
                    .offset(x: imageDescriptor.xOffset ?? 0.0)
                    .foregroundColor(fgColor)
            )
        }
    }
    
    /// Slider design used from macOS 10.15 (Catalina) through 15.0 (Sequoia).
    struct MacOS10_15Thru15MenuSlider: View {
        // MARK: Public Properties
        
        /// Value (0.0 ... 1.0).
        @Binding private var value: CGFloat
        private var label: Label?
        private let sliderImage: SliderImage?
        
        // MARK: Environment
        
        @Environment(\.colorScheme) private var colorScheme
        @Environment(\.isEnabled) private var isEnabled
        
        // MARK: Private State
        
        @State private var oldValue: CGFloat? = nil
        @State private var currentImage: Image? = nil
        @State private var currentImageView: AnyView? = nil
        
        /// Slider height.
        /// This value is fixed to mirror that of macOS's Control Center.
        /// These sliders are never found at variable heights. They can be any width however.
        private static var sliderHeight: CGFloat { 22 }
        
        // MARK: Init - Image
        
        init(value: Binding<CGFloat>, label: Label? = nil, image: SliderImage? = nil) {
            _value = value
            self.label = label
            self.sliderImage = image
        }
        
        // MARK: Body
        
        var body: some View {
            VStack(spacing: 8) {
                if let label = label {
                    HStack {
                        label
                            .font(.system(size: MenuStyling.headerFontSize, weight: .bold))
                        Spacer()
                    }
                }
                dynamicImageBody
                    .compositingGroup()
            }
            .opacity(isEnabled ? 1.0 : 0.5)
            .geometryGroupIfSupportedByPlatform()
        }
        
        @ViewBuilder
        private var dynamicImageBody: some View {
            if #available(macOS 11, *) {
                sliderBody
                    .onChange(of: value) { _ in
                        updateImage(fgColor: generateFGColor(colorScheme: colorScheme))
                    }
                    .onChange(of: colorScheme) { _ in
                        currentImageView = nil
                        updateImage(fgColor: generateFGColor(colorScheme: colorScheme), force: true)
                    }
            } else {
                // on macOS 10.15, a non-static image will not be able to change dynamically
                // from changes to `value` externally
                sliderBody
            }
        }
        
        
        @ViewBuilder
        private var sliderBody: some View {
            let fgColor = generateFGColor(colorScheme: colorScheme)
            let bgColor = generateBGColor(colorScheme: colorScheme)
            let borderColor = generateBorderColor(colorScheme: colorScheme)
            
            GeometryReader { geometry in
                let progressRangeLower: CGFloat = Self.sliderHeight / 2
                let progressRangeUpper: CGFloat = geometry.size.width - (Self.sliderHeight / 2)
                let progressRange = progressRangeLower ... progressRangeUpper.clamped(to: progressRangeLower...)
                
                let sliderRangeLower: CGFloat = 0.0
                let sliderRangeUpper: CGFloat = geometry.size.width - Self.sliderHeight
                let sliderRange = sliderRangeLower ... sliderRangeUpper.clamped(to: sliderRangeLower...)
                let fadeArea: CGFloat = (geometry.size.width / Self.sliderHeight) / 2
                
                ZStack(alignment: .center) {
                    Rectangle()
                        .background(visualEffect)
                        .foregroundColor(bgColor)
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.clear)
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: scale(value, to: progressRange).clamped(to: 0...))
                        ZStack {
                            Group {
                                Circle()
                                    .foregroundColor(.white)
                                
                                Circle()
                                    .stroke(borderColor.opacity(0.4), lineWidth: 0.5)
                                    .foregroundColor(.white)
                                    .shadow(radius: 2)
                                    .opacity(Double(value * fadeArea))
                            }
                            .frame(
                                width: Self.sliderHeight,
                                height: Self.sliderHeight,
                                alignment: .trailing
                            )
                        }
                        .offset(x: scale(value, to: sliderRange), y: 0.0)
                        
                        currentImageView
                    }
                    .frame(width: geometry.size.width)
                }
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(borderColor, lineWidth: 0.25)
                )
                .onAppear {
                    // update image
                    updateImage(fgColor: fgColor)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let calc = (value.location.x - (Self.sliderHeight / 2)) /
                            (geometry.size.width - Self.sliderHeight)
                            let newValue = min(max(0.0, calc), 1.0) // clamp
                            // assign only if value changed
                            if self.value != newValue {
                                oldValue = self.value
                                self.value = newValue
                                
                                if #available(macOS 11, *) {
                                    // don't update manually, it's being handled by onChange { }
                                } else {
                                    updateImage(fgColor: fgColor)
                                }
                            } else {
                                oldValue = self.value
                            }
                        }
                )
            }
            .frame(height: Self.sliderHeight)
            // Adding animation is a nice touch, but Apple doesn't even animate their own sliders
            // So to remain faithful, we shouldn't animate ours.
            // .animation(.linear(duration: 0.05))
        }
        
        private var visualEffect: VisualEffect? {
            if colorScheme == .dark {
                return VisualEffect(
                    .hudWindow,
                    vibrancy: true,
                    blendingMode: .behindWindow,
                    mask: nil // mask()
                )
            } else {
                return VisualEffect(
                    .underWindowBackground,
                    vibrancy: true,
                    blendingMode: .behindWindow,
                    mask: nil // mask()
                )
            }
        }
        
        private func updateImage(fgColor: Color, force: Bool = false) {
            guard let sliderImage = sliderImage else { return }
            
            func apply(imageDescriptor: MenuSliderImageDescriptor) {
                currentImage = imageDescriptor.image
                currentImageView = AnyView(
                    imageDescriptor.image
                        .scaleEffect(imageDescriptor.scale ?? 1.0, anchor: .center)
                        .offset(x: 4 + (imageDescriptor.xOffset ?? 0.0), y: 0)
                        .foregroundColor(fgColor)
                )
            }
            
            // first check if static image is being used
            if let imageDescriptor = sliderImage.staticImage(style: .macOS10_15Thru15) {
                if currentImage == nil || force {
                    apply(imageDescriptor: imageDescriptor)
                    return
                }
            }
            
            // otherwise check if a variable image is being used
            if let delta = sliderImage.deltaImage(forValue: value, oldValue: oldValue, style: .macOS10_15Thru15, force: force) {
                switch delta {
                case .noChange:
                    break
                case let .newImage(imageDescriptor):
                    apply(imageDescriptor: imageDescriptor)
                }
                return
            }
        }
        
        private func scale(_ unitIntervalValue: CGFloat, to range: ClosedRange<CGFloat>) -> CGFloat {
            range.lowerBound + (unitIntervalValue * (range.upperBound - range.lowerBound))
        }
        
        private func generateFGColor(colorScheme: ColorScheme) -> Color {
            switch colorScheme {
            case .light: return Color(NSColor.gray)
            case .dark: return Color(NSColor.controlBackgroundColor)
            @unknown default: return Color(NSColor.darkGray)
            }
        }
        
        private func generateBGColor(colorScheme: ColorScheme) -> Color {
            switch colorScheme {
            case .light: return Color(white: 0.8).opacity(0.2)
            case .dark: return Color(white: 0.3).opacity(0.5)
            @unknown default: return Color(white: 0.5)
            }
        }
        
        private func generateBorderColor(colorScheme: ColorScheme) -> Color {
            switch colorScheme {
            case .light: return Color(white: 0.5)
            case .dark: return Color(white: 0.2)
            @unknown default: return Color(white: 0.5)
            }
        }
    }
}

#if DEBUG
@available(macOS 14, *)
#Preview("Current Platform") {
    @Previewable @State var value: CGFloat = 0.5
    
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuSlider(value: $value, image: .empty)
        
        Divider()
        
        MenuSlider(value: $value, image: .static(systemName: "apple.logo"))
        
        Divider()
        
        MenuSlider("Brightness", value: $value, image: .minMax(minSystemName: "sun.min", maxSystemName: "sun.max"))
        
        Divider()
        
        MenuSlider("Volume", value: $value, image: .volume)
        
        Divider()
        
        MenuSlider(value: $value, image: .volume)
        
        Divider()
        
        MenuSlider("Volume (Disabled)", value: $value, image: .volume)
            .disabled(true)
    }
}

@available(macOS 26.0, *)
#Preview("macOS 26 Style") {
    @Previewable @State var value: CGFloat = 0.5
    
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuSlider<Text, StaticSliderImage>
            .MacOS26MenuSlider(value: $value, label: nil, image: nil)
        
        Divider()
        
        MenuSlider<Text, StaticSliderImage>
            .MacOS26MenuSlider(value: $value, label: nil, image: .static(systemName: "apple.logo"))
        
        Divider()
        
        MenuSlider<Text, MinMaxSliderImage>
            .MacOS26MenuSlider(value: $value, label: Text("Brightness"), image: .minMax(minSystemName: "sun.min", maxSystemName: "sun.max"))
        
        Divider()
        
        MenuSlider<Text, VolumeMenuSliderImage>
            .MacOS26MenuSlider(value: $value, label: Text("Volume"), image: .volume)
        
        Divider()
        
        MenuSlider<Text, VolumeMenuSliderImage>
            .MacOS26MenuSlider(value: $value, label: nil, image: .volume)
        
        Divider()
        
        MenuSlider<Text, VolumeMenuSliderImage>
            .MacOS26MenuSlider(value: $value, label: Text("Volume (Disabled)"), image: .volume)
            .disabled(true)
    }
}

@available(macOS 14, *)
#Preview("macOS 10.15-15.0 Style") {
    @Previewable @State var value: CGFloat = 0.5
    
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuSlider<Text?, EmptySliderImage>
            .MacOS10_15Thru15MenuSlider(value: $value, label: nil, image: .empty)
        
        Divider()
        
        MenuSlider<Text?, StaticSliderImage>
            .MacOS10_15Thru15MenuSlider(value: $value, label: nil, image: .static(systemName: "apple.logo"))
        
        Divider()
        
        MenuSlider<Text, MinMaxSliderImage>
            .MacOS10_15Thru15MenuSlider(value: $value, label: Text("Brightness"), image: .minMax(minSystemName: "sun.min", maxSystemName: "sun.max"))
        
        Divider()
        
        MenuSlider<Text, VolumeMenuSliderImage>
            .MacOS10_15Thru15MenuSlider(value: $value, label: Text("Volume"), image: .volume)
        
        Divider()
        
        MenuSlider<Text, VolumeMenuSliderImage>
            .MacOS10_15Thru15MenuSlider(value: $value, label: nil, image: .volume)
        
        Divider()
        
        MenuSlider<Text, VolumeMenuSliderImage>
            .MacOS10_15Thru15MenuSlider(value: $value, label: Text("Volume (Disabled)"), image: .volume)
            .disabled(true)
    }
}
#endif

#endif
