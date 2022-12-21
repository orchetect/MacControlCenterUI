//
//  ContentView.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MacControlCenterUI

struct ContentView: View {
    @State var volumeLevel: CGFloat = 0.75
    @State var brightnessLevel: CGFloat = 0.5
    @State var buttonState: Bool = false
    
    /// Based on macOS Control Center slider width
    let sliderWidth: CGFloat = 270
    
    var body: some View {
        MacControlCenterPanelView {
            if #available(macOS 11.0, *) {
                MacControlCenterPanelView {
                    MacControlCenterSlider(
                        value: $brightnessLevel,
                        label: "Display",
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
            
            Spacer().frame(height: 20)
            
            MacControlCenterPanelView {
                MacControlCenterVolumeSlider(value: $volumeLevel, label: "Sound")
                    .frame(minWidth: sliderWidth)
            }
            .frame(height: 64)
            
            Slider(value: $volumeLevel) {
                Text("\(volumeLevel)")
                    .font(.system(size: 12, design: .monospaced))
            }
            
            Spacer().frame(height: 20)
            
            MacControlCenterPanelView {
                HStack {
                    HStack {
                        MacControlCenterCircleButton(
                            isOn: $buttonState,
                            image: .macControlCenterCircleButtonSpeaker
                        ) {
                            Text("Toggle Button")
                        }
                        Spacer()
                        Toggle("On", isOn: $buttonState)
                    }
                }
                
                HStack {
                    HStack {
                        MacControlCenterCircleButton(
                            isOn: .constant(true),
                            image: .macControlCenterCircleButtonSpeaker
                        ) {
                            Text("Text Part of Button")
                        } onChange: { _ in
                            print("Clicked.")
                            NSSound.beep()
                        }
                        Spacer()
                        Text("(Static On)")
                    }
                }
                
                HStack {
                    HStack {
                        MacControlCenterCircleButton(
                            isOn: .constant(false),
                            image: .macControlCenterCircleButtonSpeaker
                        ) { _ in
                            print("Clicked.")
                            NSSound.beep()
                        }
                        Text("Text Not Part of Button")
                        Spacer()
                        Text("(Static Off)")
                    }
                }
            }
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
