//
//  ObservableScrollView.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

// idea from https://swiftwithmajid.com/2020/09/24/mastering-scrollview-in-swiftui/

/// ScrollView that provides bindable scale and scroll offset.
struct ObservableScrollView<Content: View>: View {
    let axes: Axis.Set
    let showsIndicators: Bool
    @Binding var offset: CGPoint
    @Binding var scaling: CGFloat
    let content: Content
    let contentSizeBlock: ((_ size: CGSize) -> Void)?
    
    init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        offset: Binding<CGPoint> = .constant(.zero),
        scaling: Binding<CGFloat> = .constant(1.0),
        @ViewBuilder content: () -> Content,
        contentSizeBlock: ((_ size: CGSize) -> Void)? = nil
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self._offset = offset
        self._scaling = scaling
        self.content = content()
        self.contentSizeBlock = contentSizeBlock
    }
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geometry.frame(in: .named("scrollView")).origin
                    )
                }
                .frame(width: 0, height: 0)
                
                ScrollViewReader { readerProxy in
                    ZStack {
                        content
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
                                contentSizeBlock?(newValue)
                            }
                        }
                    }
                }
            }
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            offset = value
        }
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}
