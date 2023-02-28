//
//  VisualEffectView.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Translucent visual effect background.
struct VisualEffect: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let appearance: NSAppearance.Name?
    let allowsVibrancy: Bool
    let blendingMode: NSVisualEffectView.BlendingMode
    
    init(
        _ material: NSVisualEffectView.Material = .underWindowBackground,
        appearance: NSAppearance.Name? = nil,
        vibrancy: Bool = false,
        blendingMode: NSVisualEffectView.BlendingMode = .withinWindow
    ) {
        self.material = material
        self.appearance = appearance
        self.allowsVibrancy = vibrancy
        self.blendingMode = blendingMode
    }
    
    func makeNSView(context: Self.Context) -> NSView {
        let view: NSVisualEffectView = allowsVibrancy ? VibrantVisualEffectView() : NSVisualEffectView()
        
        view.blendingMode = blendingMode
        view.state = .active
        view.material = material
        if let appearance {
            view.appearance = .init(named: appearance)
        }
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) { }
    
    private class VibrantVisualEffectView: NSVisualEffectView {
        override var allowsVibrancy: Bool { true }
    }
}

extension View {
    public func visualEffectBackground() -> some View {
        self.background(
            VisualEffect(
                .underWindowBackground,
                vibrancy: false,
                blendingMode: .behindWindow
            )
        )
    }
    
    /// Backwards compatible implementation of thin material background.
    func foregroundStyleThinMaterial() -> some View {
        if #available(macOS 13, *) {
            return self.foregroundStyle(.thinMaterial)
        } else {
            return self // .background(VisualEffect())
        }
    }
}

#endif
