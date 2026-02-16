//
//  VideoRecording.swift
//  VHSCapture
//
//  Represents a recorded video with metadata and trim information
//

import Foundation
import AVFoundation

struct VideoRecording: Identifiable, Codable {
    let id: UUID
    let url: URL
    let date: Date
    let duration: TimeInterval
    var trimStart: TimeInterval?
    var trimEnd: TimeInterval?
    var title: String

    init(id: UUID = UUID(), url: URL, date: Date = Date(), duration: TimeInterval, title: String? = nil) {
        self.id = id
        self.url = url
        self.date = date
        self.duration = duration
        self.title = title ?? "Recording \(Self.dateFormatter.string(from: date))"
    }

    var trimmedDuration: TimeInterval {
        let start = trimStart ?? 0
        let end = trimEnd ?? duration
        return end - start
    }

    var fileSize: Int64? {
        try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

extension VideoRecording {
    /// Creates a VideoRecording from an asset
    static func from(asset: AVAsset, url: URL, title: String? = nil) async -> VideoRecording? {
        guard let duration = try? await asset.load(.duration) else {
            return nil
        }

        return VideoRecording(
            url: url,
            duration: duration.seconds,
            title: title
        )
    }
}
