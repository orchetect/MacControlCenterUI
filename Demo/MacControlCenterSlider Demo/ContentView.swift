//
//  ContentView.swift
//  MacControlCenterSlider • https://github.com/orchetect/MacControlCenterSlider
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MacControlCenterSlider

struct ContentView: View {
    @State var volumeLevel: CGFloat = 0.75
    @State var brightnessLevel: CGFloat = 0.5
    
    /// Based on macOS Control Center slider width
    let sliderWidth: CGFloat = 270
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            if #available(macOS 11.0, *) {
                PanelView(label: "Display", shadow: false) {
                    MacControlCenterSlider(
                        value: $brightnessLevel,
                        image: Image(systemName: "sun.max.fill")
                    )
                    .frame(minWidth: sliderWidth)
                }
                .frame(height: 64)
            }
            
            Slider(value: $brightnessLevel) {
                Text("\(brightnessLevel)")
                    .font(.system(size: 12, design: .monospaced))
            }
            
            Spacer()
            
            PanelView(label: "Sound", shadow: true) {
                MacVolumeSlider(value: $volumeLevel)
                    .frame(minWidth: sliderWidth)
            }
            .frame(height: 64)
            
            Slider(value: $volumeLevel) {
                Text("\(volumeLevel)")
                    .font(.system(size: 12, design: .monospaced))
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
