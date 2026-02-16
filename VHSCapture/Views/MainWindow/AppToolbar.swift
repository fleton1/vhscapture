//
//  AppToolbar.swift
//  VHSCapture
//
//  Top toolbar with navigation controls
//

import SwiftUI

enum AppScreen: String, CaseIterable {
    case capture = "Capture"
    case library = "Library"

    var icon: String {
        switch self {
        case .capture:
            return "record.circle"
        case .library:
            return "film.stack"
        }
    }
}

struct AppToolbar: View {
    @Binding var currentScreen: AppScreen

    var body: some View {
        HStack {
            // Navigation segments
            Picker("View", selection: $currentScreen) {
                ForEach(AppScreen.allCases, id: \.self) { screen in
                    Label(screen.rawValue, systemImage: screen.icon)
                        .tag(screen)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 250)

            Spacer()

            // App title
            Text("VHS Capture")
                .font(.headline)

            Spacer()

            // Settings button
            Button(action: {
                // Open preferences - handled by SwiftUI Settings
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
            }) {
                Image(systemName: "gearshape")
            }
            .buttonStyle(.borderless)
            .help("Settings")
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
