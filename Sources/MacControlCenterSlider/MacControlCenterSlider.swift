//
//  MacControlCenterSlider.swift
//  MacControlCenterSlider
//

import SwiftUI

public struct MacControlCenterSlider<SliderImage>: View
where SliderImage: MacControlCenterSliderImageProtocol
{
    // MARK: Public Properties
    
    /// Value (0.0 ... 1.0).
    @Binding public var value: CGFloat
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: Private State
    
    @State private var oldValue: CGFloat? = nil
    @State private var currentImage: Image? = nil
    @State private var currentImageView: AnyView? = nil
    private let sliderImage: SliderImage?
    
    /// Slider height.
    /// This value is fixed to mirror that of macOS's Control Center.
    /// These sliders are never found at variable heights. They can be any width however.
    private static var sliderHeight: CGFloat { 22 }
    
    public init(
        value: Binding<CGFloat>,
        image: @autoclosure () -> Image
    ) where SliderImage == StaticSliderImage {
        self._value = value
        self.sliderImage = StaticSliderImage(image())
    }
    
    @_disfavoredOverload
    public init(
        value: Binding<CGFloat>,
        image: @autoclosure () -> SliderImage
    ) {
        self._value = value
        self.sliderImage = image()
    }
    
    func fgColor(colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light: return Color(NSColor.gray)
        case .dark: return Color(NSColor.controlBackgroundColor)
        @unknown default: return Color(NSColor.darkGray)
        }
    }
    func bgColor(colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light: return Color(white: 0.8)
        case .dark: return Color(white: 0.28)
        @unknown default: return Color(white: 0.5)
        }
    }
    func borderColor(colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light: return Color(white: 0.5)
        case .dark: return Color(white: 0.3)
        @unknown default: return Color(white: 0.5)
        }
    }
    
    public var body: some View {
        if #available(macOS 11, *) {
            mainBody
                .onChange(of: value) { _ in
                    updateImage(fgColor: fgColor(colorScheme: colorScheme))
                }
                .onChange(of: colorScheme) { _ in
                    currentImageView = nil
                    updateImage(fgColor: fgColor(colorScheme: colorScheme), force: true)
                }
        } else {
            // on macOS 10.15, a non-static image will not be able to change dynamically
            // from changes to `value` externally
            mainBody
        }
    }
    
    @ViewBuilder
    public var mainBody: some View {
        let fgColor = fgColor(colorScheme: colorScheme)
        let bgColor = bgColor(colorScheme: colorScheme)
        let borderColor = borderColor(colorScheme: colorScheme)
        
        GeometryReader { geometry in
            let progressRange = Self.sliderHeight / 2 ...
            geometry.size.width - (Self.sliderHeight / 2)
            let sliderRange = 0.0 ... geometry.size.width - Self.sliderHeight
            let fadeArea = (geometry.size.width / Self.sliderHeight) / 2
            
            ZStack(alignment: .center) {
                Rectangle()
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
                    .stroke(borderColor, lineWidth: 0.5)
            )
            
            .onAppear {
                // validate value
                value = value.clamped(to: 0.0 ... 1.0)
                
                // update image
                updateImage(fgColor: fgColor)
            }
            
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let calc = (value.location.x - (Self.sliderHeight / 2)) / (geometry.size.width - Self.sliderHeight)
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
                            self.oldValue = self.value
                        }
                    }
            )
        }
        .frame(height: Self.sliderHeight)
        
        // Adding animation is a nice touch, but Apple doesn't even animate their own sliders
        // So to remain faithful, we shouldn't animate ours.
        // .animation(.linear(duration: 0.05))
    }
    
    private func updateImage(fgColor: Color, force: Bool = false) {
        guard let sliderImage = sliderImage else { return }
        
        // first check if static image is being used
        if let img = sliderImage.staticImage() {
            if currentImage == nil || force {
                currentImage = img
                currentImageView = AnyView(formatStandardImage(image: img, fgColor: fgColor))
                return
            }
        }
        
        // otherwise check if a variable image is being used
        if let imgUpdate = sliderImage.image(for: value, oldValue: oldValue, force: force) {
            switch imgUpdate {
            case .noChange:
                break
            case let .newImage(newImg):
                currentImage = newImg
                if let transformed = sliderImage.transform(image: newImg, for: value) {
                    currentImageView = AnyView(
                        transformed
                            .foregroundColor(fgColor)
                    )
                } else {
                    currentImageView = AnyView(formatStandardImage(image: newImg, fgColor: fgColor))
                }
            }
            return
        }
    }
    
    private func formatStandardImage(image: Image, fgColor: Color) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(
                width: CGFloat(Self.sliderHeight - 6),
                height: CGFloat(Self.sliderHeight - 6)
            )
            .foregroundColor(fgColor)
            .offset(x: 4, y: 0)
    }
    
    private func scale(_ unitIntervalValue: CGFloat, to range: ClosedRange<CGFloat>) -> CGFloat {
        range.lowerBound + (unitIntervalValue * (range.upperBound - range.lowerBound))
    }
}

public struct StaticSliderImage: MacControlCenterSliderImageProtocol {
    private let img: Image
    
    public init(_ img: Image) {
        self.img = img
    }
    
    public func staticImage() -> Image? {
        img
    }
    
    public func image(for value: CGFloat, oldValue: CGFloat?) -> MacControlCenterSliderImageUpdate? {
        nil
    }
}
