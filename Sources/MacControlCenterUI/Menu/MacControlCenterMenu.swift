//
//  MacControlCenterMenu.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import MenuBarExtraAccess
import SwiftUI

/// macOS Control Center Menu view.
///
/// For menu-style items that highlight on mouse hover and execute code upon being clicked, use
/// the specially-provided ``MenuCommand``.
///
/// Other custom Control Center-styled controls are available as well. See the Demo project for examples.
///
/// Example Usage:
///
/// ```swift
/// @main
/// struct MyApp: App {
///     @State var isMenuPresented: Bool = false
///     @State var val: CGFloat = 0.0
///
///     var body: some Scene {
///         MenuBarExtra("MyApp") {
///             MacControlCenterMenu(isPresented: $isMenuPresented) {
///                 MenuSlider("Amount", value: $val)
///                 // using MenuCommand will auto-dismiss the popup window
///                 MenuCommand("Command 1") {
///                     print("Command 1 pressed")
///                 }
///                 MenuCommand("Command 2") {
///                     print("Command 2 pressed")
///                 }
///                 SomeCustomView {
///                     isMenuPresented = false // dismiss popup window manually
///                     doSomeStuff() // perform an action
///                 }
///                 Divider()
///                 MenuCommand("Quit") {
///                     print("Quit pressed")
///                 }
///             }
///         }
///         .menuBarExtraStyle(.window) // required to render correctly
///         .menuBarExtraAccess(isPresented: $isMenuPresented) // show/dismiss binding
///     }
/// }
/// ```
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct MacControlCenterMenu: View {
    // MARK: Public Properties
    
    @Binding public var menuBarExtraIsPresented: Bool
    public var activateAppOnCommandSelection: Bool
    public var content: [any View]
    
    // MARK: Init
    
    /// Useful for building a custom `MenuBarExtra` menu when using `.menuBarExtraStyle(.window)`.
    /// This builder allows the use of any custom View, and also supplies a special
    /// ``MenuCommand`` view for replicating clickable system menu items.
    ///
    /// - Parameters:
    ///   - isPresented: Pass the binding from `.menuBarExtraAccess(isPresented:)` here.
    ///   - activateAppOnCommandSelection: Activate the app before executing
    ///     command action blocks. This is often necessary since menubar items
    ///     can be accessed while the app is not in focus. This will allow
    ///     actions that open a window to bring the window (and app) to the front.
    ///     Note that this setting only applies to ``MenuCommand`` instances within the menu.
    ///   - content: Menu item builder content.
    public init(
        isPresented: Binding<Bool>,
        activateAppOnCommandSelection: Bool = true,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) {
        _menuBarExtraIsPresented = isPresented
        self.activateAppOnCommandSelection = activateAppOnCommandSelection
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        ZStack(alignment: .top) {
            menuBody
            
            // not sure why this helps, but it keeps the window in place when its size changes
            // and prevents janky view animations
            Spacer().frame(minHeight: 0)
        }
        .background(VisualEffect.popoverWindow())
    }
    
    @ViewBuilder
    private var menuBody: some View {
        MenuBody(content: content) { item in
            item
                .environment(\.isMenuBarExtraPresented, $menuBarExtraIsPresented)
        }
        .padding([.top, .bottom], MenuGeometry.menuPadding)
    }
}

#endif
