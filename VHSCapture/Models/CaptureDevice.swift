//
//  CaptureDevice.swift
//  VHSCapture
//
//  Represents a USB video capture device
//

import AVFoundation
import Foundation

struct CaptureDevice: Identifiable, Hashable {
    let id: String
    let name: String
    let device: AVCaptureDevice

    init(device: AVCaptureDevice) {
        self.id = device.uniqueID
        self.name = device.localizedName
        self.device = device
    }

    static func == (lhs: CaptureDevice, rhs: CaptureDevice) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CaptureDevice {
    /// Returns all available USB video capture devices
    static func discoverDevices() -> [CaptureDevice] {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.externalUnknown, .builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )

        return discoverySession.devices.map { CaptureDevice(device: $0) }
    }
}
