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
    @State var button1State: Bool = true
    @State var button2State: Bool = true
    @State var button3State: Bool = true
    @State var button4State: Bool = true
    
    /// Based on macOS Control Center slider width
    let sliderWidth: CGFloat = 270
    
    var body: some View {
        MenuPanel {
            MenuPanel {
                MenuSlider(
                    "Display",
                    value: $brightnessLevel,
                    image: Image(systemName: "sun.max.fill")
                )
                .frame(minWidth: sliderWidth)
            }
            .frame(height: 64)
            
            Slider(value: $brightnessLevel) {
                Text("\(brightnessLevel)")
                    .font(.system(size: 12, design: .monospaced))
            }
            
            Spacer().frame(height: 20)
            
            MenuPanel {
                MenuVolumeSlider("Sound", value: $volumeLevel)
                    .frame(minWidth: sliderWidth)
            }
            .frame(height: 64)
            
            Slider(value: $volumeLevel) {
                Text("\(volumeLevel)")
                    .font(.system(size: 12, design: .monospaced))
            }
            
            Spacer().frame(height: 20)
            
            MenuPanel {
                HStack {
                    MenuCircleToggle(
                        "Toggle Button",
                        isOn: $button1State,
                        image: Image(systemName: "speaker.wave.2.fill")
                    )
                    Spacer()
                    Toggle("On", isOn: $button1State)
                }
                
                HStack {
                    MenuCircleToggle(
                        "Toggle Button (White)",
                        isOn: $button2State,
                        style: .init(
                            image: Image(systemName: "speaker.wave.2.fill"),
                            color: .white,
                            invertForeground: true
                        )
                    )
                    Spacer()
                    Toggle("On", isOn: $button2State)
                }
                
                HStack {
                    MenuCircleToggle(
                        "Toggle Button (Orange)",
                        isOn: $button3State,
                        style: .init(
                            image: Image(systemName: "sun.max.fill"),
                            color: .orange
                        )
                    )
                    Spacer()
                    Toggle("On", isOn: $button3State)
                }
                
                HStack {
                    HStack {
                        MenuCircleToggle(
                            isOn: $button4State,
                            image: Image(systemName: "speaker.wave.2.fill")
                        )
                        Text("Text Not Clickable")
                        Spacer()
                        Toggle("On", isOn: $button4State)
                    }
                }
                
                HStack {
                    HStack {
                        MenuCircleToggle(
                            isOn: .constant(true),
                            image: Image(systemName: "speaker.wave.2.fill")
                        ) {
                            Text("Button")
                        } onClick: { _ in
                            print("Clicked.")
                            NSSound.beep()
                        }
                        Spacer()
                        Text("(Static On)")
                    }
                }
                
                HStack {
                    HStack {
                        MenuCircleToggle(
                            isOn: .constant(false),
                            image: Image(systemName: "speaker.wave.2.fill")
                        ) {
                            Text("Button")
                        } onClick: { _ in
                            print("Clicked.")
                            NSSound.beep()
                        }
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
