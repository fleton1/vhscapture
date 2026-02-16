//
//  CaptureViewModel.swift
//  VHSCapture
//
//  Manages capture state and coordinates between UI and CaptureService
//

import AVFoundation
import Combine
import SwiftUI

@MainActor
class CaptureViewModel: ObservableObject {
    @Published var selectedDevice: CaptureDevice?
    @Published var availableDevices: [CaptureDevice] = []
    @Published var isRecording = false
    @Published var recordingDuration: TimeInterval = 0
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var isSessionRunning = false

    private let captureService = CaptureService()
    private let deviceDiscovery = DeviceDiscoveryService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
        discoverDevices()
    }

    private func setupBindings() {
        // Bind device discovery
        deviceDiscovery.$availableDevices
            .receive(on: DispatchQueue.main)
            .assign(to: &$availableDevices)

        deviceDiscovery.$selectedDevice
            .receive(on: DispatchQueue.main)
            .assign(to: &$selectedDevice)

        // Bind capture service
        captureService.$isRecording
            .receive(on: DispatchQueue.main)
            .assign(to: &$isRecording)

        captureService.$recordingDuration
            .receive(on: DispatchQueue.main)
            .assign(to: &$recordingDuration)

        captureService.$previewLayer
            .receive(on: DispatchQueue.main)
            .assign(to: &$previewLayer)

        captureService.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
            }
            .store(in: &cancellables)

        // Listen for recording completion
        NotificationCenter.default.publisher(for: .recordingDidFinish)
            .sink { [weak self] notification in
                self?.handleRecordingFinished(notification)
            }
            .store(in: &cancellables)
    }

    func discoverDevices() {
        deviceDiscovery.discoverDevices()
    }

    func selectDevice(_ device: CaptureDevice) {
        deviceDiscovery.selectDevice(device)
        Task {
            await setupCaptureSession()
        }
    }

    func setupCaptureSession() async {
        guard let device = selectedDevice else { return }

        do {
            try await captureService.setupCaptureSession(with: device)
            captureService.startSession()
            isSessionRunning = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func startRecording() {
        guard let device = selectedDevice else {
            errorMessage = "No device selected"
            showError = true
            return
        }

        let filename = FileManager.generateRecordingFilename()
        let outputURL = FileManager.temporaryRecordingsDirectory.appendingPathComponent(filename)

        do {
            try captureService.startRecording(to: outputURL)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func stopRecording() {
        captureService.stopRecording()
    }

    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    private func handleRecordingFinished(_ notification: Notification) {
        guard let url = notification.userInfo?["url"] as? URL else { return }

        Task {
            // Create VideoRecording from the file
            let asset = AVAsset(url: url)
            if let recording = await VideoRecording.from(asset: asset, url: url) {
                // Post notification with the new recording
                NotificationCenter.default.post(
                    name: .newRecordingCreated,
                    object: nil,
                    userInfo: ["recording": recording]
                )
            }
        }
    }
}

// MARK: - Notifications
extension Notification.Name {
    static let newRecordingCreated = Notification.Name("newRecordingCreated")
}
