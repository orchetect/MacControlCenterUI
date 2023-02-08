//
//  MacControlCenterMenu.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// macOS Control Center Menu view.
/// For menu-style items that highlight on mouse hover and execute code upon being clicked, use
/// the specially-provided ``MenuCommand``.
///
/// Example Usage:
///
/// ```swift
/// @main
/// struct MyApp: App {
///     @State var val: CGFloat = 0.0
///
///     var body: some Scene {
///         MenuBarExtra("MyApp") {
///             MacControlCenterMenu {
///                 MacControlCenterSlider("Amount", value: $val)
///                 MenuCommand("Command 1") {
///                     print("Command 1 pressed")
///                 }
///                 MenuCommand("Command 2") {
///                     print("Command 2 pressed")
///                 }
///                 Divider()
///                 MenuCommand("Quit") {
///                     print("Quit pressed")
///                 }
///             }
///         }
///         .menuBarExtraStyle(.window) // required to render correctly
///     }
/// }
/// ```
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MacControlCenterMenu: View {
    public var content: [any View]
    public var activateAppOnCommandSelection: Bool
    
    // MARK: Init
    
    public init(
        activateAppOnCommandSelection: Bool = true,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) {
        self.activateAppOnCommandSelection = activateAppOnCommandSelection
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    unwrapContent
                }
                //Spacer()
            }
        }
        .padding([.top, .bottom], menuPadding)
    }
    
    // MARK: Helpers
    
    private var unwrapContent: some View {
        ForEach(content.indices, id: \.self) {
            convertView(content[$0])
        }
    }
    
    private func convertView(_ view: any View) -> AnyView {
        switch view {
        case is (any MacControlCenterMenuItem):
            return AnyView(view)
            
        default:
            let wrappedView = MenuItem {
                AnyView(view)
            }
            return AnyView(wrappedView)
        }
    }
}
