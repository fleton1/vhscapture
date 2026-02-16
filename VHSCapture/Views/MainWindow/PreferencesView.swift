//
//  PreferencesView.swift
//  VHSCapture
//
//  Application preferences/settings window
//

import SwiftUI

struct PreferencesView: View {
    @AppStorage("defaultCodec") private var defaultCodec = VideoCodec.h264.rawValue
    @AppStorage("defaultQuality") private var defaultQuality = 0.8
    @AppStorage("autoTrim") private var autoTrim = true

    var body: some View {
        TabView {
            GeneralPreferencesView(
                defaultCodec: $defaultCodec,
                defaultQuality: $defaultQuality,
                autoTrim: $autoTrim
            )
            .tabItem {
                Label("General", systemImage: "gearshape")
            }

            StoragePreferencesView()
                .tabItem {
                    Label("Storage", systemImage: "externaldrive")
                }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(width: 500, height: 400)
    }
}

struct GeneralPreferencesView: View {
    @Binding var defaultCodec: String
    @Binding var defaultQuality: Double
    @Binding var autoTrim: Bool

    var body: some View {
        Form {
            Section("Export Defaults") {
                Picker("Default Codec", selection: $defaultCodec) {
                    ForEach(VideoCodec.allCases) { codec in
                        Text(codec.rawValue).tag(codec.rawValue)
                    }
                }

                HStack {
                    Text("Default Quality")
                    Slider(value: $defaultQuality, in: 0.3...1.0)
                    Text("\(Int(defaultQuality * 100))%")
                        .frame(width: 50)
                }
            }

            Section("Workflow") {
                Toggle("Auto-navigate to trim after capture", isOn: $autoTrim)
            }
        }
        .padding()
    }
}

struct StoragePreferencesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Storage Location")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                Text("Recordings are stored in:")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(FileManager.appSupportDirectory.path)
                    .font(.system(.caption, design: .monospaced))
                    .textSelection(.enabled)
                    .padding(8)
                    .background(Color(nsColor: .textBackgroundColor))
                    .cornerRadius(4)
            }

            Button("Show in Finder") {
                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: FileManager.appSupportDirectory.path)
            }

            Divider()

            Button("Clean Up Temporary Files") {
                FileManager.default.cleanupTemporaryFiles()
            }

            Text("Removes temporary files older than 7 days")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)

            Text("VHS Capture")
                .font(.title)

            Text("Version 1.0.0")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("A modern macOS application for USB video capture and VHS digitization")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Divider()
                .padding(.vertical)

            VStack(spacing: 8) {
                Text("Built with Swift and SwiftUI")
                    .font(.caption2)
                    .foregroundColor(.secondary)

                Text("© 2024")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PreferencesView()
}
