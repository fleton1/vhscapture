//
//  FileManager+Extensions.swift
//  VHSCapture
//
//  File management utilities for temporary and persistent storage
//

import Foundation

extension FileManager {
    /// Returns the app's temporary recordings directory
    static var temporaryRecordingsDirectory: URL {
        let temp = FileManager.default.temporaryDirectory
        let recordingsDir = temp.appendingPathComponent("VHSCapture/Recordings", isDirectory: true)
        try? FileManager.default.createDirectory(at: recordingsDir, withIntermediateDirectories: true)
        return recordingsDir
    }

    /// Returns the app's application support directory
    static var appSupportDirectory: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let appDir = appSupport.appendingPathComponent("VHSCapture", isDirectory: true)
        try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
        return appDir
    }

    /// Generates a unique filename for a new recording
    static func generateRecordingFilename() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let dateString = dateFormatter.string(from: Date())
        return "Recording_\(dateString).mov"
    }

    /// Returns file size in bytes, or nil if file doesn't exist
    func fileSize(at url: URL) -> Int64? {
        guard let attributes = try? attributesOfItem(atPath: url.path) else {
            return nil
        }
        return attributes[.size] as? Int64
    }

    /// Cleans up old temporary files
    func cleanupTemporaryFiles(olderThan days: Int = 7) {
        let tempDir = FileManager.temporaryRecordingsDirectory
        guard let files = try? contentsOfDirectory(at: tempDir, includingPropertiesForKeys: [.creationDateKey]) else {
            return
        }

        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()

        for file in files {
            guard let attributes = try? attributesOfItem(atPath: file.path),
                  let creationDate = attributes[.creationDate] as? Date,
                  creationDate < cutoffDate else {
                continue
            }

            try? removeItem(at: file)
        }
    }
}
