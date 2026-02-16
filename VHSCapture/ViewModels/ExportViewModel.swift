//
//  ExportViewModel.swift
//  VHSCapture
//
//  Manages video export with codec and quality settings
//

import AVFoundation
import SwiftUI
import UniformTypeIdentifiers

@MainActor
class ExportViewModel: ObservableObject {
    @Published var recording: VideoRecording
    @Published var settings = ExportSettings()
    @Published var isExporting = false
    @Published var exportProgress: Double = 0
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var exportCompleted = false

    private let exportService = ExportService()

    init(recording: VideoRecording) {
        self.recording = recording
    }

    func selectExportLocation() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.mpeg4Movie]
        panel.nameFieldStringValue = suggestedFilename()
        panel.message = "Choose where to save your video"
        panel.canCreateDirectories = true

        panel.begin { [weak self] response in
            guard let self = self, response == .OK, let url = panel.url else { return }

            Task {
                await self.exportVideo(to: url)
            }
        }
    }

    func exportVideo(to destinationURL: URL) async {
        isExporting = true
        exportProgress = 0
        exportCompleted = false

        do {
            try await exportService.exportVideo(
                from: recording.url,
                to: destinationURL,
                settings: settings
            ) { [weak self] progress in
                Task { @MainActor in
                    self?.exportProgress = progress
                }
            }

            exportCompleted = true
            isExporting = false

            // Show in Finder
            NSWorkspace.shared.selectFile(destinationURL.path, inFileViewerRootedAtPath: "")

        } catch {
            errorMessage = error.localizedDescription
            showError = true
            isExporting = false
        }
    }

    func cancelExport() {
        exportService.cancelExport()
        isExporting = false
        exportProgress = 0
    }

    private func suggestedFilename() -> String {
        let basename = recording.url.deletingPathExtension().lastPathComponent
        return "\(basename).\(settings.codec.fileExtension)"
    }

    var estimatedFileSize: String {
        guard let originalSize = recording.fileSize else {
            return "Unknown"
        }

        // Rough estimate based on codec and quality
        let compressionFactor: Double
        switch settings.codec {
        case .h264:
            compressionFactor = settings.quality * 0.8
        case .h265:
            compressionFactor = settings.quality * 0.5 // HEVC is more efficient
        }

        let estimatedBytes = Int64(Double(originalSize) * compressionFactor)
        return TimeFormatter.formatFileSize(estimatedBytes)
    }
}
