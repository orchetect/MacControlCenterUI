//
//  MenuScrollView.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// ``MacControlCenterMenu`` scroll view with with automatic sizing and custom scroll indicators.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuScrollView: View, MacControlCenterMenuItem {
    public var content: [any View]
    public var maxHeight: CGFloat
    
    @State private var scrollPosition: CGPoint = .zero
    @State private var contentHeight: CGFloat = .zero
    
    public init(
        maxHeight: CGFloat = 300,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) {
        self.maxHeight = maxHeight.clamped(to: 0...)
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            ObservableScrollView(
                .vertical,
                offset: $scrollPosition,
                contentHeight: $contentHeight
            ) {
                MenuBody(content: content)
            }
            
            VStack(spacing: 0) {
                Group {
                    if scrollPosition.y < -1 {
                        Image(systemName: "chevron.compact.up")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    } else {
                        Spacer()
                    }
                }
                .frame(height: 5)
                
                Spacer()
                
                Group {
                    if scrollPosition.y > maxHeight - contentHeight {
                        Image(systemName: "chevron.compact.down")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    } else {
                        Spacer()
                    }
                }
                .frame(height: 5)
            }
        }
        .frame(height: min(maxHeight, contentHeight))
    }
}
