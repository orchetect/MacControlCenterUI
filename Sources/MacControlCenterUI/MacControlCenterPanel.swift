//
//  MacControlCenterPanel.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MacControlCenterPanel<Content: View>: View {
    // MARK: Public Properties
    
    public var shadow: Bool
    public var content: () -> Content
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: Init
    
    public init(
        shadow: Bool = true,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.shadow = shadow
        self.content = content
    }
    
    // MARK: Body
    
    public var body: some View {
        let panelColor = Color(NSColor.windowBackgroundColor).opacity(0.5)
        
        ZStack(alignment: .top) {
            if shadow {
                RoundedRectangle(cornerRadius: 10)
                    .fill(panelColor)
                    .shadow(color: Color(white: 0, opacity: 0.25), radius: 3)
            }
            RoundedRectangle(cornerRadius: 10)
                .fill(panelColor)
            
            // macOS Control Center only borders the panel in Dark mode
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(white: 0.1), lineWidth: 0.5)
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(white: 0.3), lineWidth: 0.5)
                    .padding(0.5)
            }
            
            VStack(spacing: 8) {
                content()
            }
            .padding(10)
        }
    }
}
