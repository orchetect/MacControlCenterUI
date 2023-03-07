//
//  AppDelegate.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import SwiftUI
import MacControlCenterUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView()
            .background(VisualEffect.popoverWindow())
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 400),
            styleMask: [.borderless, .titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        //window.hasShadow = false
        //window.backgroundColor = .clear
        
        window.isReleasedWhenClosed = false
        window.center()
        window.title = "Mac Control Center UI Demo"
        //window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

