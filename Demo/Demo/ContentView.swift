//
//  ContentView.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import MacControlCenterUI
import SwiftUI

struct ContentView: View {
    @Environment(MenuModel.self) var model

    @State private var delayedTask: Task<Void, any Error>?

    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "message.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondary)

            Text("Open this menu bar button in the system menu bar.")

            Form {
                Section("Debug Functions") {
                    VStack(alignment: .leading, spacing: 2) {
                        LabeledContent {
                            Button("Randomize Now") {
                                model.randomizeState()
                            }
                        } label: {
                            Text("Randomize Menu State")

                        }

                        Text("""
                            Randomizing menu state while the menu is closed allows testing the behavior \
                            of initial menu animations when the menu is next opened.
                            """
                        )
                        .textScale(.secondary)
                        .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        LabeledContent {
                            HStack {
                                if delayedTask != nil {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .controlSize(.small)
                                }

                                Button("Randomize in 5 Seconds") {
                                    startDelayedStateRandomization()
                                }
                                .disabled(delayedTask != nil)
                            }
                        } label: {
                            Text("Randomize Menu State")
                        }

                        Text("""
                            Randomizing menu state while the menu is open allows testing the behavior \
                            of menu animations when state changes while the menu is visible.
                            """
                        )
                        .textScale(.secondary)
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .formStyle(.grouped)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: 600)
        }
        .padding()
        .frame(minWidth: 500, minHeight: 460)
    }

    private func startDelayedStateRandomization() {
        // cancel pending task, if any
        delayedTask?.cancel()
        delayedTask = nil

        // start new delayed task
        delayedTask = Task {
            try await Task.sleep(for: .seconds(5))
            model.randomizeState()
            delayedTask?.cancel()
            delayedTask = nil
        }
    }
}
