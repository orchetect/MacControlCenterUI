//
//  MenuSectionText.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// ``MacControlCenterMenu`` section text view.
/// This view is not commonly used by itself. It is more typical to use ``MenuSection`` instead.
public struct MenuSectionText<Content: View>: View {
    // MARK: Public Properties
    
    public let content: Content
    
    // MARK: Init
    
    public init(text: Text) where Content == Text {
        self.content = text
    }
    
    internal init(_ content: Content) {
        self.content = content
    }
    
    // MARK: Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    public var body: some View {
        content
            .font(.system(size: MenuStyling.headerFontSize, weight: .semibold))
            .foregroundColor(foreColor)
    }
    
    private var foreColor: Color {
        colorScheme == .dark
            ? Color(white: 1).opacity(0.6)
            : Color(white: 0).opacity(0.7)
    }
}

#endif
