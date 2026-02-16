//
//  TrimView.swift
//  VHSCapture
//
//  Video trimming interface with timeline and controls
//

import SwiftUI
import AVKit

struct TrimView: View {
    @StateObject private var viewModel: TrimViewModel
    let onTrimCompleted: () -> Void

    init(recording: VideoRecording, onTrimCompleted: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: TrimViewModel(recording: recording))
        self.onTrimCompleted = onTrimCompleted
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top info bar
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.recording.title)
                        .font(.headline)

                    HStack(spacing: 16) {
                        Label(
                            TimeFormatter.formatDuration(viewModel.recording.duration),
                            systemImage: "clock"
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)

                        if let fileSize = viewModel.recording.fileSize {
                            Label(
                                TimeFormatter.formatFileSize(fileSize),
                                systemImage: "doc"
                            )
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer()

                // Apply trim button
                Button(action: {
                    Task {
                        await viewModel.applyTrim()
                        onTrimCompleted()
                    }
                }) {
                    HStack {
                        if viewModel.isProcessing {
                            ProgressView()
                                .controlSize(.small)
                        }
                        Text(viewModel.isProcessing ? "Processing..." : "Apply Trim")
                    }
                    .frame(minWidth: 120)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isProcessing || viewModel.trimStart >= viewModel.trimEnd)
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))

            // Video player
            ZStack {
                Color.black

                if let player = viewModel.player {
                    VideoPlayer(player: player)
                        .disabled(true) // Disable built-in controls
                }
            }

            // Trim info
            HStack {
                HStack(spacing: 4) {
                    Text("Start:")
                        .foregroundColor(.secondary)
                    Text(TimeFormatter.formatTimecode(viewModel.trimStart))
                        .font(.system(.body, design: .monospaced))
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("Trimmed Duration")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(TimeFormatter.formatDuration(viewModel.trimmedDuration))
                        .font(.system(.title3, design: .monospaced))
                }

                Spacer()

                HStack(spacing: 4) {
                    Text("End:")
                        .foregroundColor(.secondary)
                    Text(TimeFormatter.formatTimecode(viewModel.trimEnd))
                        .font(.system(.body, design: .monospaced))
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)

            // Timeline
            VStack(spacing: 12) {
                TimelineView(viewModel: viewModel)
                    .frame(height: 60)
                    .padding(.horizontal)

                // Current time indicator
                Text(TimeFormatter.formatTimecode(viewModel.currentTime))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)

            // Playback controls
            TrimControlsView(viewModel: viewModel)
                .padding()
                .background(Color(nsColor: .controlBackgroundColor))

            // Processing progress
            if viewModel.isProcessing {
                VStack(spacing: 8) {
                    ProgressView(value: viewModel.processingProgress)
                        .padding(.horizontal)

                    Text("Processing: \(Int(viewModel.processingProgress * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(nsColor: .controlBackgroundColor))
            }
        }
    }
}
