//
//  CaptureService.swift
//  VHSCapture
//
//  Manages AVCaptureSession for video recording from USB devices
//

import AVFoundation
import Combine

enum CaptureError: Error, LocalizedError {
    case noDevice
    case setupFailed
    case permissionDenied
    case recordingFailed

    var errorDescription: String? {
        switch self {
        case .noDevice:
            return "No capture device selected"
        case .setupFailed:
            return "Failed to setup capture session"
        case .permissionDenied:
            return "Camera and microphone permissions are required"
        case .recordingFailed:
            return "Failed to start recording"
        }
    }
}

class CaptureService: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var recordingDuration: TimeInterval = 0
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    @Published var error: CaptureError?

    private let session = AVCaptureSession()
    private var movieOutput: AVCaptureMovieFileOutput?
    private var currentOutputURL: URL?
    private var recordingTimer: Timer?
    private var recordingStartTime: Date?

    private let sessionQueue = DispatchQueue(label: "com.vhscapture.session")

    override init() {
        super.init()
        setupPreviewLayer()
    }

    private func setupPreviewLayer() {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspect
        DispatchQueue.main.async {
            self.previewLayer = layer
        }
    }

    func setupCaptureSession(with device: CaptureDevice) async throws {
        // Request permissions first
        let authorized = await requestPermissions()
        guard authorized else {
            throw CaptureError.permissionDenied
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            sessionQueue.async { [weak self] in
                guard let self = self else {
                    continuation.resume(throwing: CaptureError.setupFailed)
                    return
                }

                self.session.beginConfiguration()
                defer { self.session.commitConfiguration() }

                // Remove existing inputs
                self.session.inputs.forEach { self.session.removeInput($0) }

                // Add video input
                do {
                    let videoInput = try AVCaptureDeviceInput(device: device.device)
                    if self.session.canAddInput(videoInput) {
                        self.session.addInput(videoInput)
                    }

                    // Add audio input if available
                    if let audioDevice = AVCaptureDevice.default(for: .audio) {
                        let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                        if self.session.canAddInput(audioInput) {
                            self.session.addInput(audioInput)
                        }
                    }

                    // Setup movie file output
                    let movieOutput = AVCaptureMovieFileOutput()
                    if self.session.canAddOutput(movieOutput) {
                        self.session.addOutput(movieOutput)
                        self.movieOutput = movieOutput
                    }

                    continuation.resume()
                } catch {
                    continuation.resume(throwing: CaptureError.setupFailed)
                }
            }
        }
    }

    func startSession() {
        sessionQueue.async { [weak self] in
            self?.session.startRunning()
        }
    }

    func stopSession() {
        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
        }
    }

    func startRecording(to url: URL) throws {
        guard let output = movieOutput else {
            throw CaptureError.setupFailed
        }

        guard !isRecording else { return }

        // Ensure parent directory exists
        let directory = url.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        currentOutputURL = url
        output.startRecording(to: url, recordingDelegate: self)

        DispatchQueue.main.async {
            self.isRecording = true
            self.recordingStartTime = Date()
            self.startRecordingTimer()
        }
    }

    func stopRecording() {
        movieOutput?.stopRecording()
        stopRecordingTimer()

        DispatchQueue.main.async {
            self.isRecording = false
            self.recordingDuration = 0
        }
    }

    private func startRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.recordingStartTime else { return }
            self.recordingDuration = Date().timeIntervalSince(startTime)
        }
    }

    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        recordingStartTime = nil
    }

    private func requestPermissions() async -> Bool {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)

        let cameraAuthorized: Bool
        if cameraStatus == .notDetermined {
            cameraAuthorized = await AVCaptureDevice.requestAccess(for: .video)
        } else {
            cameraAuthorized = cameraStatus == .authorized
        }

        let audioAuthorized: Bool
        if audioStatus == .notDetermined {
            audioAuthorized = await AVCaptureDevice.requestAccess(for: .audio)
        } else {
            audioAuthorized = audioStatus == .authorized
        }

        return cameraAuthorized && audioAuthorized
    }
}

// MARK: - AVCaptureFileOutputRecordingDelegate
extension CaptureService: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        DispatchQueue.main.async {
            if let error = error {
                print("Recording error: \(error.localizedDescription)")
            }

            // Post notification that recording finished
            NotificationCenter.default.post(
                name: .recordingDidFinish,
                object: nil,
                userInfo: ["url": outputFileURL]
            )
        }
    }
}

// MARK: - Notifications
extension Notification.Name {
    static let recordingDidFinish = Notification.Name("recordingDidFinish")
}
