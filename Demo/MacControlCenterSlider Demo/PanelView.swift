//
//  PanelView.swift
//  MacControlCenterSlider • https://github.com/orchetect/MacControlCenterSlider
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct PanelView<Content: View>: View {
    var label: String
    var shadow: Bool = false
    var content: () -> Content
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let panelColor = Color(NSColor.windowBackgroundColor)
        
        ZStack {
            if shadow {
                RoundedRectangle(cornerRadius: 10)
                    .fill(panelColor)
                    .shadow(color: Color(white: 0, opacity: 0.25), radius: 3)
            }
            RoundedRectangle(cornerRadius: 10)
                .fill(panelColor)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(label)")
                    .font(.system(size: 12, weight: .semibold))
                
                content()
            }
            .padding(10)
            
            // macOS Control Center only borders the panel in Dark mode
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(white: 0.1), lineWidth: 0.5)
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(white: 0.3), lineWidth: 0.5)
                    .padding(0.5)
            }
        }
    }
}
