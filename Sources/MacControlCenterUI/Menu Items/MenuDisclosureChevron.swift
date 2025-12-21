//
//  MenuDisclosureChevron.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Disclosure chevron used in ``MacControlCenterMenu`` items.
public struct MenuDisclosureChevron: View {
    // MARK: Public Properties
    
    public let size: CGFloat
    @Binding public var isExpanded: Bool
    
    // MARK: Environment
    
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: Private State
    
    @State private var isPressed: Bool = false
    @State private var frame: CGRect = .zero
    @State private var rotationAngle: Angle = .zero
    
    // MARK: Init
    
    public init(
        size: CGFloat = 10,
        isExpanded: Binding<Bool>
    ) {
        self.size = size
        _isExpanded = isExpanded
    }
    
    // MARK: Body
    
    public var body: some View {
        chevronBody
            .geometryGroupIfSupportedByPlatform()
            .onChange(of: isEnabled) { newValue in
                if !isEnabled {
                    isPressed = false
                }
            }
    }
    
    @ViewBuilder
    private var chevronBody: some View {
        if #available(macOS 13.0, *) {
            imageBody
                .gesture(gesture)
                .onGeometryChange(for: CGRect.self) { proxy in
                    proxy.frame(in: .local)
                } action: { newFrame in
                    frame = newFrame
                }
        } else { // TODO: delete when package min req. is bumped to macOS 13
            GeometryReader { geometry in
                imageBody
                    .gesture(gesture)
                    .onAppear { frame = geometry.frame(in: .local) }
                    .onChange(of: geometry.frame(in: .local)) { newValue in
                        frame = newValue
                    }
            }
            .frame(width: size, height: size)
        }
    }
    
    private var imageBody: some View {
        Image(systemName: "chevron.right")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .contentShape(Rectangle())
            .foregroundColor(.primary)
            .rotationEffect(rotationAngle)
            .opacity(opacityValue)
            // .animation(.default, value: isExpanded) // avoid, causes side effects
        
            .onAppear {
                updateState()
            }
            .onChange(of: isExpanded) { _ in
                handleRotation()
            }
    }
        
    private var gesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                guard isEnabled else { return }
                let hit = frame.contains(value.location)
                isPressed = hit
            }
            .onEnded { value in
                guard isEnabled else { return }
                defer { isPressed = false }
                if isPressed {
                    isExpanded.toggle()
                }
            }
    }
    
    private func handleRotation() {
        withAnimation {
            updateState()
        }
    }
    
    private func updateState() {
        rotationAngle = isExpanded ? .degrees(90) : .zero
    }
    
    private var opacityValue: CGFloat {
        guard isEnabled else { return 0.4 }
        return isPressed ? 0.7 : 1.0
    }
}

#endif
