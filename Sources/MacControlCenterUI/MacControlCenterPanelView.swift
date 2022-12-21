//
//  MacControlCenterPanelView.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MacControlCenterPanelView<Content: View>: View {
    public var label: String?
    public var shadow: Bool
    public var content: () -> Content
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(
        label: String? = nil,
        shadow: Bool = true,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.label = label
        self.shadow = shadow
        self.content = content
    }
    
    public var body: some View {
        let panelColor = Color(NSColor.windowBackgroundColor)
        
        ZStack {
            if shadow {
                RoundedRectangle(cornerRadius: 10)
                    .fill(panelColor)
                    .shadow(color: Color(white: 0, opacity: 0.25), radius: 3)
            }
            RoundedRectangle(cornerRadius: 10)
                .fill(panelColor)
            
            VStack(spacing: 8) {
                if let label = label {
                    HStack {
                        Text("\(label)")
                            .font(.system(size: 12, weight: .semibold))
                        Spacer()
                    }
                }
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
