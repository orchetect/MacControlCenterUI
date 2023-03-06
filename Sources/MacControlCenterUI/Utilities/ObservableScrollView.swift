//
//  ObservableScrollView.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

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
        self._offset = offset
        self._scaling = scaling
        self.content = content()
        self._contentHeight = contentHeight
    }
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    Color.clear.environment(\.scrollOffset, geometry.frame(in: .named(coordSpace)).origin)
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
                            Color.clear.onChange(of: geometry.size) { newValue in
                                guard newValue.height > 0 else { return }
                                contentHeight = newValue.height
                            }
                        }
                    }
                }
            }
        }
        .coordinateSpace(name: coordSpace)
        ._onEnvironmentChange(\.scrollOffset) { newValue in
            offset = newValue
        }
    }
}

fileprivate struct ScrollOffsetKey: EnvironmentKey {
    static var defaultValue: CGPoint = .zero
}

extension EnvironmentValues {
    fileprivate var scrollOffset: CGPoint {
        get { self[ScrollOffsetKey.self] }
        set { self[ScrollOffsetKey.self] = newValue }
    }
}
