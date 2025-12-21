//
//  MenuScrollView.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// ``MacControlCenterMenu`` scroll view with with automatic sizing and custom scroll indicators.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MenuScrollView: View, MacControlCenterMenuItem {
    public var content: [any View]
    public var maxHeight: CGFloat
    public var showsIndicators: Bool
    public var disableScrollIfFullContentIsVisible: Bool
    
    @State private var scrollPosition: CGPoint = .zero
    @State private var contentHeight: CGFloat = .zero
    
    public init(
        maxHeight: CGFloat = 300,
        showsIndicators: Bool = true,
        disableScrollIfFullContentIsVisible: Bool = true,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) {
        self.maxHeight = maxHeight.clamped(to: 0...)
        self.showsIndicators = showsIndicators
        self.disableScrollIfFullContentIsVisible = disableScrollIfFullContentIsVisible
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            ObservableScrollView(
                .vertical,
                showsIndicators: showsIndicators,
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
        .frame(height: frameHeight)
        .geometryGroupIfSupportedByPlatform()
        .scrollDisabledIfSupportedByPlatform(isScrollDisabled)
    }
    
    private var frameHeight: CGFloat {
        min(maxHeight, contentHeight)
    }
    
    private var isScrollDisabled: Bool {
        guard disableScrollIfFullContentIsVisible else { return false }
        return isFullContentIsVisible
    }
    
    private var isFullContentIsVisible: Bool {
        contentHeight <= maxHeight
    }
}

#endif
