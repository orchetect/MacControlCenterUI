//
//  ObservableScrollView.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Combine
import SwiftUI

// idea from https://swiftwithmajid.com/2020/09/24/mastering-scrollview-in-swiftui/

/// ScrollView that provides bindable scale and scroll offset.
struct ObservableScrollView<Content: View>: View, MacControlCenterMenuItem {
    let axes: Axis.Set
    let showsIndicators: Bool
    @Binding var offset: CGPoint
    @Binding var scaling: CGFloat
    let content: Content
    @Binding var contentHeight: CGFloat
    
    private let coordSpace = UUID().uuidString
    
    init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        offset: Binding<CGPoint> = .constant(.zero),
        scaling: Binding<CGFloat> = .constant(1.0),
        contentHeight: Binding<CGFloat>,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        _offset = offset
        _scaling = scaling
        self.content = content()
        _contentHeight = contentHeight
    }
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geometry.frame(in: .named(coordSpace)).origin
                    )
                }
                .frame(width: 0, height: 0)
                
                ScrollViewReader { readerProxy in
                    ZStack {
                        VStack {
                            content
                        }
                        .scaleEffect(scaling)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    withAnimation {
                                        scaling = value.magnitude
                                    }
                                }
                        )
                        GeometryReader { geometry in
                            Color.clear
                                .onReceive(Just(geometry.size)) { newValue in
                                    // must use onReceive and not onChange, otherwise if the view is removed and reinserted,
                                    // contentHeight's state will be reset to default (.zero)
                                    guard newValue.height > 0 else { return }
                                    contentHeight = newValue.height
                                }
                        }
                    }
                }
            }
        }
        .coordinateSpace(name: coordSpace)
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            Task { @MainActor in offset = value }
        }
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

#endif
