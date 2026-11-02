//
//  MouseHoverModifier.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

extension View {
    func onMouseHover(perform action: @escaping (_ isHovering: Bool) -> Void) -> some View {
        modifier(MouseHoverModifier(action: action))
    }
}

struct MouseHoverModifier: ViewModifier {
    let action: (_ isHovering: Bool) -> Void

    init(action: @escaping (_ isHovering: Bool) -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Representable(
                        action: action,
                        frame: proxy.frame(in: .global)
                    )
                }
            )
    }

    private struct Representable: NSViewRepresentable {
        let action: (_ isHovering: Bool) -> Void
        let frame: NSRect

        func makeCoordinator() -> Coordinator {
            let coordinator = Coordinator()
            coordinator.action = action
            return coordinator
        }

        class Coordinator: NSResponder {
            var action: ((_ isHovering: Bool) -> Void)?

            override func mouseEntered(with event: NSEvent) {
                action?(true)
            }

            override func mouseExited(with event: NSEvent) {
                action?(false)
            }
        }

        func makeNSView(context: Context) -> NSView {
            let view = NSView(frame: frame)

            let options: NSTrackingArea.Options = [
                .activeInKeyWindow,
                .inVisibleRect,
                .mouseEnteredAndExited
            ]

            let trackingArea = NSTrackingArea(
                rect: frame,
                options: options,
                owner: context.coordinator,
                userInfo: nil
            )

            view.addTrackingArea(trackingArea)

            return view
        }

        func updateNSView(_ nsView: NSView, context: Context) { }

        static func dismantleNSView(_ nsView: NSView, coordinator: Coordinator) {
            for trackingArea in nsView.trackingAreas {
                nsView.removeTrackingArea(trackingArea)
            }
        }
    }
}

#endif
