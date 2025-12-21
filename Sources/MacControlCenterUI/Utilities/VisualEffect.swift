//
//  VisualEffect.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Translucent visual effect background.
@available(macOS, deprecated: 26.0, message: "Deprecated. Use .background(.ultraThinMaterial) or liquid glass effects instead.")
public struct VisualEffect: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let appearance: NSAppearance.Name?
    let allowsVibrancy: Bool
    let blendingMode: NSVisualEffectView.BlendingMode
    let mask: NSImage?
    
    public init(
        _ material: NSVisualEffectView.Material = .underWindowBackground,
        appearance: NSAppearance.Name? = nil,
        vibrancy: Bool = false,
        blendingMode: NSVisualEffectView.BlendingMode = .withinWindow,
        mask: NSImage? = nil
    ) {
        self.material = material
        self.appearance = appearance
        allowsVibrancy = vibrancy
        self.blendingMode = blendingMode
        self.mask = mask
    }
    
    public func makeNSView(context: Self.Context) -> NSView {
        let view: NSVisualEffectView = allowsVibrancy ? VibrantVisualEffectView() : NSVisualEffectView()
        
        view.blendingMode = blendingMode
        view.state = .active
        view.material = material
        view.maskImage = mask
        if let appearance {
            view.appearance = .init(named: appearance)
        } else { view.appearance = nil }
        
        return view
    }
    
    public func updateNSView(_ nsView: NSView, context: Context) { }
    
    private class VibrantVisualEffectView: NSVisualEffectView {
        override var allowsVibrancy: Bool { true }
    }
}

// MARK: - Static Constructors

extension VisualEffect {
    @available(macOS, deprecated: 26.0, message: "Deprecated. Use .background(.ultraThinMaterial) or liquid glass effects instead.")
    public static func nonVibrant(mask: NSImage? = nil) -> Self {
        VisualEffect(
            .underWindowBackground,
            vibrancy: false,
            blendingMode: .behindWindow,
            mask: mask
        )
    }
    
    @available(macOS, deprecated: 26.0, message: "Deprecated. Use .background(.ultraThinMaterial) or liquid glass effects instead.")
    public static func vibrant(mask: NSImage? = nil) -> Self {
        VisualEffect(
            .underWindowBackground,
            vibrancy: true,
            blendingMode: .behindWindow,
            mask: mask
        )
    }
    
    /// Mimics the macOS Control Center / system menus translucency.
    @available(macOS, deprecated: 26.0, message: "Deprecated. Use .background(.ultraThinMaterial) or liquid glass effects instead.")
    public static func popoverWindow() -> Self {
        VisualEffect(
            .popover,
            vibrancy: false,
            blendingMode: .behindWindow
        )
    }
}

// MARK: - View Modifiers

extension View {
    /// Applies the appropriate window background effect for the menu based on the current platform.
    func menuBackgroundEffectForCurrentPlatform() -> some View {
        if #available(macOS 26.0, *) {
            return self
                .backgroundStyle(.ultraThinMaterial /*. thinMaterial */)
                .windowResizeAnchor(.topLeading) // helps with smooth menu window resize animations
        } else {
            return self
                .background(VisualEffect.popoverWindow())
        }
    }
    
    /// Backwards compatible implementation of thin material background.
    func foregroundStyleThinMaterialIfSupportedByPlatform() -> some View {
        if #available(macOS 13.0, *) {
            return self.foregroundStyle(.thinMaterial)
        } else {
            return self // .background(VisualEffect())
        }
    }
    
    /// Backwards compatible implementation of geometry group.
    func geometryGroupIfSupportedByPlatform() -> some View {
        if #available(macOS 14.0, *) {
            return self.geometryGroup()
        } else {
            return self
        }
    }
    
    /// Backwards compatible implementation of the `scrollDisabled` view modifier.
    func scrollDisabledIfSupportedByPlatform(_ disabled: Bool) -> some View {
        if #available(macOS 13.0, *) {
            return self.scrollDisabled(disabled)
        } else {
            return self
        }
    }
}

// MARK: - Animation

extension Animation {
    /// Animation that mimics the menu resize animation that macOS Control Center menus implement.
    public static var macControlCenterMenuResize: Animation {
        // this closely mimics menu height resize animation on macOS 26.2
        
        // ideally it would be something a bit slower (like .smooth), but as of macOS 26.2 SwiftUI seems
        // to resize windows a very fast, static speed. so we have no choice but to match it as best we can.
        
        .smooth(duration: 0.2, extraBounce: 0.25)
    }
}

#endif
