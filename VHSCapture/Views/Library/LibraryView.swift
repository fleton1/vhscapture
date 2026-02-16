//
//  LibraryView.swift
//  VHSCapture
//
//  Library of recorded videos
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var project: VideoProject
    let onRecordingSelected: (VideoRecording) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Recordings")
                    .font(.headline)

                Spacer()

                Text("\(project.recordings.count) videos")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            if project.recordings.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 1) {
                        ForEach(project.recordings) { recording in
                            RecordingRow(recording: recording)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    onRecordingSelected(recording)
                                }
                                .contextMenu {
                                    Button("Show in Finder") {
                                        NSWorkspace.shared.selectFile(
                                            recording.url.path,
                                            inFileViewerRootedAtPath: ""
                                        )
                                    }

                                    Divider()

                                    Button("Delete", role: .destructive) {
                                        project.removeRecording(recording)
                                    }
                                }
                        }
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "film.stack")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No Recordings Yet")
                .font(.title3)
                .foregroundColor(.secondary)

            Text("Start capturing to create your first recording")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct RecordingRow: View {
    let recording: VideoRecording

    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.black)
                .frame(width: 80, height: 60)
                .overlay(
                    Image(systemName: "film")
                        .foregroundColor(.white.opacity(0.5))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(recording.title)
                    .font(.headline)
                    .lineLimit(1)

                HStack(spacing: 12) {
                    Label(
                        TimeFormatter.formatDuration(recording.duration),
                        systemImage: "clock"
                    )

                    if let fileSize = recording.fileSize {
                        Label(
                            TimeFormatter.formatFileSize(fileSize),
                            systemImage: "doc"
                        )
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)

                Text(formatDate(recording.date))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
