//
//  MenuPanel.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuPanel<Content: View>: View {
    // MARK: Public Properties
    
    public var hasShadow: Bool
    public var content: () -> Content
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: Init
    
    public init(
        hasShadow: Bool = true,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.hasShadow = hasShadow
        self.content = content
    }
    
    // MARK: Body
    
    public var body: some View {
        let panelColor = Color(NSColor.windowBackgroundColor).opacity(0.25)
        
        ZStack(alignment: .top) {
            if hasShadow {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .shadow(color: Color(white: 0, opacity: 1), radius: 2)
            }
            RoundedRectangle(cornerRadius: 10)
                .fill(panelColor)
            
            // macOS Control Center only borders the panel in Dark mode
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(white: 0.1, opacity: 0.5), lineWidth: 0.5)
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(white: 0.4), lineWidth: 0.5)
                    .padding(0.5)
            }
            
            VStack(spacing: 8) {
                content()
            }
            .padding(10)
        }
        .geometryGroupIfSupportedByPlatform()
    }
}

#endif
