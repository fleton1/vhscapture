//
//  ContentView.swift
//  VHSCapture
//
//  Main application view with navigation and workflow management
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var project = VideoProject()
    @State private var currentScreen: AppScreen = .capture
    @State private var selectedRecording: VideoRecording?
    @State private var workflowState: WorkflowState = .capture
    @State private var cancellables = Set<AnyCancellable>()

    enum WorkflowState {
        case capture
        case trim(VideoRecording)
        case export(VideoRecording)
        case library
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top toolbar
            AppToolbar(currentScreen: $currentScreen)

            Divider()

            // Main content area
            Group {
                switch workflowState {
                case .capture:
                    CaptureView()

                case .trim(let recording):
                    TrimView(recording: recording) {
                        // After trim completes, return to capture
                        workflowState = .capture
                        currentScreen = .library
                    }

                case .export(let recording):
                    ExportView(recording: recording)

                case .library:
                    LibraryView(project: project) { recording in
                        selectedRecording = recording
                        workflowState = .trim(recording)
                    }
                }
            }
        }
        .onChange(of: currentScreen) { oldValue, newValue in
            handleScreenChange(newValue)
        }
        .onAppear {
            setupNotifications()
        }
    }

    private func handleScreenChange(_ screen: AppScreen) {
        switch screen {
        case .capture:
            workflowState = .capture
        case .library:
            workflowState = .library
        }
    }

    private func setupNotifications() {
        // Listen for new recordings
        NotificationCenter.default.publisher(for: .newRecordingCreated)
            .sink { notification in
                if let recording = notification.userInfo?["recording"] as? VideoRecording {
                    project.addRecording(recording)

                    // Auto-navigate to trim view
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        workflowState = .trim(recording)
                    }
                }
            }
            .store(in: &cancellables)

        // Listen for trim completion
        NotificationCenter.default.publisher(for: .trimCompleted)
            .sink { notification in
                if let recording = notification.userInfo?["recording"] as? VideoRecording {
                    // Auto-navigate to export view
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        workflowState = .export(recording)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

#Preview {
    ContentView()
        .frame(width: 900, height: 600)
}
