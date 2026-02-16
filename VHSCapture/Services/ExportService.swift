//
//  ExportService.swift
//  VHSCapture
//
//  Handles video export with codec and quality settings
//

import AVFoundation
import Foundation

enum ExportError: Error, LocalizedError {
    case invalidSource
    case exportFailed(String)
    case cancelled

    var errorDescription: String? {
        switch self {
        case .invalidSource:
            return "Invalid video source"
        case .exportFailed(let message):
            return "Export failed: \(message)"
        case .cancelled:
            return "Export cancelled"
        }
    }
}

class ExportService: ObservableObject {
    @Published var progress: Double = 0
    @Published var isExporting = false

    private var currentExportSession: AVAssetExportSession?

    func exportVideo(
        from sourceURL: URL,
        to destinationURL: URL,
        settings: ExportSettings,
        progressHandler: @escaping (Double) -> Void
    ) async throws {
        let asset = AVAsset(url: sourceURL)

        // Determine preset based on quality
        let preset = presetForQuality(settings.quality)

        guard let exportSession = AVAssetExportSession(asset: asset, presetName: preset) else {
            throw ExportError.invalidSource
        }

        self.currentExportSession = exportSession

        exportSession.outputURL = destinationURL
        exportSession.outputFileType = .mp4

        // Configure video settings for codec
        let videoSettings = await configureVideoSettings(
            for: asset,
            codec: settings.codec,
            resolution: settings.resolution
        )

        if !videoSettings.isEmpty {
            exportSession.videoComposition = AVMutableVideoComposition(
                propertiesOf: asset
            )
        }

        DispatchQueue.main.async {
            self.isExporting = true
            self.progress = 0
        }

        // Monitor progress
        let progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let currentProgress = Double(exportSession.progress)
            DispatchQueue.main.async {
                self.progress = currentProgress
                progressHandler(currentProgress)
            }
        }

        await exportSession.export()

        progressTimer.invalidate()

        DispatchQueue.main.async {
            self.isExporting = false
            self.currentExportSession = nil
        }

        switch exportSession.status {
        case .completed:
            DispatchQueue.main.async {
                self.progress = 1.0
                progressHandler(1.0)
            }
        case .failed:
            let errorMessage = exportSession.error?.localizedDescription ?? "Unknown error"
            throw ExportError.exportFailed(errorMessage)
        case .cancelled:
            throw ExportError.cancelled
        default:
            break
        }
    }

    func cancelExport() {
        currentExportSession?.cancelExport()
        DispatchQueue.main.async {
            self.isExporting = false
            self.progress = 0
        }
    }

    private func presetForQuality(_ quality: Double) -> String {
        if quality >= 0.9 {
            return AVAssetExportPresetHighestQuality
        } else if quality >= 0.7 {
            return AVAssetExportPreset1920x1080
        } else if quality >= 0.5 {
            return AVAssetExportPreset1280x720
        } else {
            return AVAssetExportPreset960x540
        }
    }

    private func configureVideoSettings(
        for asset: AVAsset,
        codec: VideoCodec,
        resolution: VideoResolution?
    ) async -> [String: Any] {
        var settings: [String: Any] = [:]

        // Note: AVAssetExportSession preset determines codec
        // For H.265/HEVC, use HEVCHighestQualityWithAlpha or HEVC presets if needed
        // The preset handles most codec selection automatically

        if let resolution = resolution, let dimensions = resolution.dimensions {
            settings[AVVideoWidthKey] = dimensions.width
            settings[AVVideoHeightKey] = dimensions.height
        }

        return settings
    }
}
