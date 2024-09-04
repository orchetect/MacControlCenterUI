//
//  ContentView.swift
//  MacControlCenterUIDemoApp • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MacControlCenterUI

struct ContentView: View {
    @Binding var isMenuPresented: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "message.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondary)
            
            Text("Explore this menu bar button in the system status bar.")
            
            Text("Or toggle me:")
            
            Toggle("", isOn: $isMenuPresented)
                .toggleStyle(.switch)
                .labelsHidden()
        }
        .padding()
        .frame(minWidth: 500, minHeight: 350)
        .background(VisualEffect.nonVibrant())
    }
}
