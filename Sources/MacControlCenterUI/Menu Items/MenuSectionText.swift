//
//  MenuSectionText.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// ``MacControlCenterMenu`` section text view.
/// This view is not commonly used by itself unless composing views with specific layout needs.
/// It is more typical to use ``MenuSection`` instead.
public struct MenuSectionText<Content: View>: View {
    // MARK: Public Properties
    
    public let content: Content
    
    // MARK: Init
    
    @_disfavoredOverload
    public init<S>(_ text: S) where S: StringProtocol, Content == Text {
        self.content = Text(text)
    }
    
    public init(_ titleKey: LocalizedStringKey) where Content == Text {
        self.content = Text(titleKey)
    }
    
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    @_disfavoredOverload
    public init(_ titleResource: LocalizedStringResource) where Content == Text {
        self.content = Text(titleResource)
    }
    
    @_disfavoredOverload
    public init(_ text: Text) where Content == Text {
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
            .geometryGroupIfSupportedByPlatform()
    }
    
    private var foreColor: Color {
        colorScheme == .dark
            ? Color(white: 1).opacity(0.6)
            : Color(white: 0).opacity(0.7)
    }
}

#endif
