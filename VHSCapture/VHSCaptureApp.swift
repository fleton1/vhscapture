//
//  VHSCaptureApp.swift
//  VHSCapture
//
//  A modern macOS application for USB video capture and VHS digitization
//

import SwiftUI

@main
struct VHSCaptureApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }

        Settings {
            PreferencesView()
        }
    }
}
