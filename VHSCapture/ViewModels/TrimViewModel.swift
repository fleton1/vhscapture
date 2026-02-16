//
//  TrimViewModel.swift
//  VHSCapture
//
//  Manages video trimming state and timeline interactions
//

import AVFoundation
import AVKit
import Combine
import SwiftUI

@MainActor
class TrimViewModel: ObservableObject {
    @Published var recording: VideoRecording
    @Published var player: AVPlayer?
    @Published var currentTime: TimeInterval = 0
    @Published var trimStart: TimeInterval = 0
    @Published var trimEnd: TimeInterval
    @Published var isPlaying = false
    @Published var isProcessing = false
    @Published var processingProgress: Double = 0

    private let processingService = VideoProcessingService()
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()

    init(recording: VideoRecording) {
        self.recording = recording
        self.trimStart = recording.trimStart ?? 0
        self.trimEnd = recording.trimEnd ?? recording.duration
        setupPlayer()
    }

    deinit {
        removeTimeObserver()
    }

    private func setupPlayer() {
        let asset = AVAsset(url: recording.url)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        // Observe playback time
        let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
        }

        // Observe when player reaches end
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                self?.isPlaying = false
                self?.seekToTrimStart()
            }
            .store(in: &cancellables)
    }

    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }

    func togglePlayback() {
        guard let player = player else { return }

        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            // If at or past trim end, restart from trim start
            if currentTime >= trimEnd {
                seekToTrimStart()
            }
            player.play()
            isPlaying = true
        }
    }

    func seek(to time: TimeInterval) {
        let clampedTime = max(0, min(time, recording.duration))
        let cmTime = CMTime(seconds: clampedTime, preferredTimescale: 600)
        player?.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
        currentTime = clampedTime
    }

    func seekToTrimStart() {
        seek(to: trimStart)
    }

    func seekToTrimEnd() {
        seek(to: trimEnd)
    }

    func setTrimStart() {
        trimStart = currentTime
        if trimEnd <= trimStart {
            trimEnd = min(trimStart + 1, recording.duration)
        }
    }

    func setTrimEnd() {
        trimEnd = currentTime
        if trimStart >= trimEnd {
            trimStart = max(0, trimEnd - 1)
        }
    }

    func updateTrimStart(_ value: TimeInterval) {
        trimStart = max(0, min(value, trimEnd - 0.1))
    }

    func updateTrimEnd(_ value: TimeInterval) {
        trimEnd = max(trimStart + 0.1, min(value, recording.duration))
    }

    func applyTrim() async {
        guard trimStart < trimEnd else { return }

        isProcessing = true
        processingProgress = 0

        let filename = "Trimmed_\(FileManager.generateRecordingFilename())"
        let outputURL = FileManager.temporaryRecordingsDirectory.appendingPathComponent(filename)

        do {
            try await processingService.trimVideo(
                from: recording.url,
                to: outputURL,
                startTime: trimStart,
                endTime: trimEnd
            ) { [weak self] progress in
                Task { @MainActor in
                    self?.processingProgress = progress
                }
            }

            // Create new recording with trimmed video
            let asset = AVAsset(url: outputURL)
            if let newRecording = await VideoRecording.from(
                asset: asset,
                url: outputURL,
                title: "Trimmed - \(recording.title)"
            ) {
                NotificationCenter.default.post(
                    name: .newRecordingCreated,
                    object: nil,
                    userInfo: ["recording": newRecording]
                )

                NotificationCenter.default.post(
                    name: .trimCompleted,
                    object: nil,
                    userInfo: ["recording": newRecording]
                )
            }

            isProcessing = false
        } catch {
            print("Trim error: \(error.localizedDescription)")
            isProcessing = false
        }
    }

    var trimmedDuration: TimeInterval {
        trimEnd - trimStart
    }
}

// MARK: - Notifications
extension Notification.Name {
    static let trimCompleted = Notification.Name("trimCompleted")
}
