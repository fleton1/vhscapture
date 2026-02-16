//
//  VideoProject.swift
//  VHSCapture
//
//  Manages the collection of video recordings
//

import Foundation

class VideoProject: ObservableObject {
    @Published var recordings: [VideoRecording] = []

    private let storageURL: URL
    private let metadataURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let appDir = appSupport.appendingPathComponent("VHSCapture", isDirectory: true)

        self.storageURL = appDir.appendingPathComponent("Recordings", isDirectory: true)
        self.metadataURL = appDir.appendingPathComponent("recordings.json")

        setupStorage()
        loadRecordings()
    }

    private func setupStorage() {
        try? FileManager.default.createDirectory(at: storageURL, withIntermediateDirectories: true)
    }

    func addRecording(_ recording: VideoRecording) {
        recordings.append(recording)
        saveRecordings()
    }

    func removeRecording(_ recording: VideoRecording) {
        recordings.removeAll { $0.id == recording.id }
        try? FileManager.default.removeItem(at: recording.url)
        saveRecordings()
    }

    func updateRecording(_ recording: VideoRecording) {
        if let index = recordings.firstIndex(where: { $0.id == recording.id }) {
            recordings[index] = recording
            saveRecordings()
        }
    }

    private func saveRecordings() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(recordings) {
            try? data.write(to: metadataURL)
        }
    }

    private func loadRecordings() {
        guard let data = try? Data(contentsOf: metadataURL) else { return }
        let decoder = JSONDecoder()
        recordings = (try? decoder.decode([VideoRecording].self, from: data)) ?? []
    }

    func getStorageURL() -> URL {
        storageURL
    }
}
