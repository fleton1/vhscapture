//
//  VideoProcessingService.swift
//  VHSCapture
//
//  Handles video trimming and processing operations
//

import AVFoundation
import Foundation

enum ProcessingError: Error, LocalizedError {
    case invalidAsset
    case exportFailed
    case invalidTimeRange

    var errorDescription: String? {
        switch self {
        case .invalidAsset:
            return "Invalid video file"
        case .exportFailed:
            return "Failed to process video"
        case .invalidTimeRange:
            return "Invalid trim range"
        }
    }
}

class VideoProcessingService {
    func trimVideo(
        from sourceURL: URL,
        to destinationURL: URL,
        startTime: TimeInterval,
        endTime: TimeInterval,
        progressHandler: @escaping (Double) -> Void
    ) async throws {
        let asset = AVAsset(url: sourceURL)

        let start = CMTime(seconds: startTime, preferredTimescale: 600)
        let end = CMTime(seconds: endTime, preferredTimescale: 600)
        let timeRange = CMTimeRange(start: start, end: end)

        guard timeRange.duration.seconds > 0 else {
            throw ProcessingError.invalidTimeRange
        }

        guard let exportSession = AVAssetExportSession(
            asset: asset,
            presetName: AVAssetExportPresetHighestQuality
        ) else {
            throw ProcessingError.exportFailed
        }

        exportSession.outputURL = destinationURL
        exportSession.outputFileType = .mov
        exportSession.timeRange = timeRange

        // Monitor progress
        let progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            DispatchQueue.main.async {
                progressHandler(Double(exportSession.progress))
            }
        }

        await exportSession.export()

        progressTimer.invalidate()

        switch exportSession.status {
        case .completed:
            progressHandler(1.0)
        case .failed, .cancelled:
            throw ProcessingError.exportFailed
        default:
            break
        }
    }

    func generateThumbnail(for asset: AVAsset, at time: TimeInterval) async throws -> NSImage {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero

        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        let cgImage = try await imageGenerator.image(at: cmTime).image

        return NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
    }

    func getVideoDuration(for url: URL) async throws -> TimeInterval {
        let asset = AVAsset(url: url)
        let duration = try await asset.load(.duration)
        return duration.seconds
    }
}
