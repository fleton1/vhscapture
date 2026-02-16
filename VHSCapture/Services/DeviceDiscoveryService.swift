//
//  DeviceDiscoveryService.swift
//  VHSCapture
//
//  Discovers and monitors USB video capture devices
//

import AVFoundation
import Combine

class DeviceDiscoveryService: ObservableObject {
    @Published var availableDevices: [CaptureDevice] = []
    @Published var selectedDevice: CaptureDevice?

    private var deviceObserver: Any?

    init() {
        discoverDevices()
        setupDeviceMonitoring()
    }

    deinit {
        if let observer = deviceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    func discoverDevices() {
        availableDevices = CaptureDevice.discoverDevices()

        // Auto-select first device if none selected
        if selectedDevice == nil {
            selectedDevice = availableDevices.first
        }
    }

    private func setupDeviceMonitoring() {
        // Monitor for device connections/disconnections
        deviceObserver = NotificationCenter.default.addObserver(
            forName: .AVCaptureDeviceWasConnected,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.discoverDevices()
        }

        NotificationCenter.default.addObserver(
            forName: .AVCaptureDeviceWasDisconnected,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.discoverDevices()
        }
    }

    func selectDevice(_ device: CaptureDevice) {
        selectedDevice = device
    }
}
