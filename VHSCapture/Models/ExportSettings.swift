//
//  ExportSettings.swift
//  VHSCapture
//
//  Configuration for video export and codec selection
//

import Foundation
import AVFoundation

struct ExportSettings {
    var codec: VideoCodec
    var quality: Double // 0.0 to 1.0
    var resolution: VideoResolution?

    init(codec: VideoCodec = .h264, quality: Double = 0.8, resolution: VideoResolution? = nil) {
        self.codec = codec
        self.quality = quality
        self.resolution = resolution
    }
}

enum VideoCodec: String, CaseIterable, Identifiable {
    case h264 = "H.264"
    case h265 = "H.265 (HEVC)"

    var id: String { rawValue }

    var codecType: String {
        switch self {
        case .h264:
            return AVVideoCodecType.h264.rawValue
        case .h265:
            return AVVideoCodecType.hevc.rawValue
        }
    }

    var fileExtension: String {
        "mp4"
    }
}

enum VideoResolution: String, CaseIterable, Identifiable {
    case original = "Original"
    case hd1080 = "1080p"
    case hd720 = "720p"
    case sd480 = "480p"

    var id: String { rawValue }

    var dimensions: (width: Int, height: Int)? {
        switch self {
        case .original:
            return nil
        case .hd1080:
            return (1920, 1080)
        case .hd720:
            return (1280, 720)
        case .sd480:
            return (720, 480)
        }
    }
}
