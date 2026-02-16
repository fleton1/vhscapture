//
//  ExportView.swift
//  VHSCapture
//
//  Video export interface with codec and quality selection
//

import SwiftUI
import AVKit

struct ExportView: View {
    @StateObject private var viewModel: ExportViewModel

    init(recording: VideoRecording) {
        _viewModel = StateObject(wrappedValue: ExportViewModel(recording: recording))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top info bar
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Export Video")
                        .font(.headline)

                    Text(viewModel.recording.title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if viewModel.exportCompleted {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Export Complete")
                    }
                }
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))

            ScrollView {
                VStack(spacing: 24) {
                    // Preview thumbnail
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black)
                        .aspectRatio(4/3, contentMode: .fit)
                        .overlay(
                            Image(systemName: "film")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.3))
                        )
                        .frame(maxWidth: 400)

                    // Export settings
                    VStack(spacing: 20) {
                        GroupBox("Format") {
                            VStack(alignment: .leading, spacing: 12) {
                                Picker("Codec", selection: $viewModel.settings.codec) {
                                    ForEach(VideoCodec.allCases) { codec in
                                        Text(codec.rawValue).tag(codec)
                                    }
                                }
                                .pickerStyle(.segmented)

                                HStack {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.secondary)

                                    Text(codecDescription)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(8)
                        }

                        GroupBox("Quality") {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Lower")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Slider(value: $viewModel.settings.quality, in: 0.3...1.0)

                                    Text("Higher")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                HStack {
                                    Text("Quality: \(Int(viewModel.settings.quality * 100))%")
                                        .font(.caption)

                                    Spacer()

                                    Text("Est. size: \(viewModel.estimatedFileSize)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(8)
                        }

                        GroupBox("Resolution") {
                            Picker("Resolution", selection: $viewModel.settings.resolution) {
                                ForEach([nil] + VideoResolution.allCases, id: \.self) { resolution in
                                    Text(resolution?.rawValue ?? "Original").tag(resolution)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(8)
                        }

                        // Video info
                        GroupBox("Video Information") {
                            VStack(spacing: 8) {
                                InfoRow(
                                    label: "Duration",
                                    value: TimeFormatter.formatDuration(viewModel.recording.duration)
                                )

                                if let fileSize = viewModel.recording.fileSize {
                                    InfoRow(
                                        label: "Original Size",
                                        value: TimeFormatter.formatFileSize(fileSize)
                                    )
                                }

                                InfoRow(
                                    label: "Created",
                                    value: formatDate(viewModel.recording.date)
                                )
                            }
                            .padding(8)
                        }
                    }
                    .padding()
                }
            }

            Divider()

            // Export progress
            if viewModel.isExporting {
                ExportProgressView(
                    progress: viewModel.exportProgress,
                    isExporting: viewModel.isExporting
                )
                .padding()
                .background(Color(nsColor: .controlBackgroundColor))
            }

            // Bottom buttons
            HStack {
                if viewModel.isExporting {
                    Button("Cancel") {
                        viewModel.cancelExport()
                    }
                } else {
                    Button("Export...") {
                        viewModel.selectExportLocation()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))
        }
        .alert("Export Error", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.showError = false
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }

    private var codecDescription: String {
        switch viewModel.settings.codec {
        case .h264:
            return "H.264 offers good quality and wide compatibility"
        case .h265:
            return "H.265 (HEVC) provides better compression but may be slower to encode"
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
        .font(.caption)
    }
}
