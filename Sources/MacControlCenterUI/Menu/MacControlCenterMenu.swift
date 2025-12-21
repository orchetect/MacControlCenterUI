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
    public var width: MenuWidth?
    public var activateAppOnCommandSelection: Bool
    public var content: [any View]
    
    // MARK: Init
    
    /// Useful for building a custom `MenuBarExtra` menu when using `.menuBarExtraStyle(.window)`.
    /// This builder allows the use of any custom View, and also supplies a special
    /// ``MenuCommand`` view for replicating clickable system menu items.
    ///
    /// - Parameters:
    ///   - isPresented: Pass the binding from `.menuBarExtraAccess(isPresented:)` here.
    ///   - width: Select a standard menu width for the `currentPlatform()` or manually specify.
    ///     If `nil`, the menu is not constrained.
    ///   - activateAppOnCommandSelection: Activate the app before executing
    ///     command action blocks. This is often necessary since menubar items
    ///     can be accessed while the app is not in focus. This will allow
    ///     actions that open a window to bring the window (and app) to the front.
    ///     Note that this setting only applies to ``MenuCommand`` instances within the menu.
    ///   - content: Menu item builder content.
    public init(
        isPresented: Binding<Bool>,
        width: MenuWidth? = .currentPlatform(),
        activateAppOnCommandSelection: Bool = true,
        @MacControlCenterMenuBuilder _ content: () -> [any View]
    ) {
        _menuBarExtraIsPresented = isPresented
        self.width = width
        self.activateAppOnCommandSelection = activateAppOnCommandSelection
        self.content = content()
    }
    
    // MARK: Body
    
    public var body: some View {
        Group {
            if #available(macOS 26, *) {
                menuBodyMacOS26
            } else {
                menuBodyMacOS10_15Thru15
            }
        }
    }
    
    @available(macOS 26, *)
    public var menuBodyMacOS26: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(height: MenuGeometry.menuPadding)
            
            MenuScrollView(
                maxHeight: maxMenuHeight,
                showsIndicators: true,
                disableScrollIfFullContentIsVisible: true
            ) {
                MenuBody(content: content) { item in
                    item
                        .environment(\.isMenuBarExtraPresented, $menuBarExtraIsPresented)
                }
            }
            
            Spacer()
                .frame(height: MenuGeometry.menuPadding)
        }
        .frame(width: width?.width)
        .menuBackgroundEffectForCurrentPlatform()
        .geometryGroupIfSupportedByPlatform()
    }
    
    public var menuBodyMacOS10_15Thru15: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: MenuGeometry.menuPadding)
                
                MenuScrollView(
                    maxHeight: maxMenuHeight,
                    showsIndicators: true,
                    disableScrollIfFullContentIsVisible: true
                ) {
                    MenuBody(content: content) { item in
                        item
                            .environment(\.isMenuBarExtraPresented, $menuBarExtraIsPresented)
                    }
                }
                
                Spacer()
                    .frame(height: MenuGeometry.menuPadding)
            }
            
            // not sure why this helps, but it keeps the window in place when its size changes
            // and prevents janky view animations
            Spacer().frame(minHeight: 0)
        }
        .frame(width: width?.width)
        .menuBackgroundEffectForCurrentPlatform()
    }
    
    // MARK: - Computed Properties
    
    private var maxMenuHeight: CGFloat {
        // `NSScreen.main`:
        // The main screen is not necessarily the same screen that contains the menu bar or has its origin at
        // (0, 0). The main screen refers to the screen containing the window that is currently receiving
        // keyboard events.
        // It will however reference the currently focused screen if user has "Displays have separate Spaces"
        // enabled in System Preferences -> Mission Control.
        
        // `NSScreen.screens`:
        // The screen at index 0 in the returned array corresponds to the primary screen of the user’s system.
        // This is the screen that contains the menu bar and whose origin is at the point (0, 0).
        
        // `visibleFrame`:
        // The returned rectangle is always based on the current user-interface settings and does not include
        // the area currently occupied by the dock and menu bar.
        
        guard let availableScreenHeight = NSScreen.screens.first?.visibleFrame.height else {
            // should never happen, but provide a reasonable default just in case we get nil
            return 800
        }
        
        // TODO: If the screen resolution changes or the user modifies system display configuration, this value might not recalculate in response. It might require adding a system notification observer to detect when screen geometry has changed.
        
        return availableScreenHeight - 30 // allow for a modest margin to add spacing
    }
}

#if DEBUG
#Preview("Default Width for Current Platform") {
    MacControlCenterMenu(isPresented: .constant(true)) {
        MenuHeader("Header")
        MenuCommand("Test Command") { }
        
        MenuSection("Section", divider: true)
        MenuCommand("Test Command") { }
    }
}

#Preview("macOS 26 Width") {
    MacControlCenterMenu(isPresented: .constant(true), width: .macOS26) {
        MenuHeader("Header")
        MenuCommand("Test Command") { }
        
        MenuSection("Section", divider: true)
        MenuCommand("Test Command") { }
    }
}

#Preview("macOS 11-15 Width") {
    MacControlCenterMenu(isPresented: .constant(true), width: .macOS11Thru15) {
        MenuHeader("Header")
        MenuCommand("Test Command") { }
        
        MenuSection("Section", divider: true)
        MenuCommand("Test Command") { }
    }
}

#Preview("No Width Constraint") {
    MacControlCenterMenu(isPresented: .constant(true), width: nil) {
        MenuHeader("Header")
        MenuCommand("Test Command") { }
        
        MenuSection("Section", divider: true)
        MenuCommand("Test Command") { }
    }
}
#endif

#endif
