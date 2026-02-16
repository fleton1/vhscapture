//
//  CaptureView.swift
//  VHSCapture
//
//  Main capture interface with live preview and recording controls
//

import SwiftUI

struct CaptureView: View {
    @StateObject private var viewModel = CaptureViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Top toolbar with device picker
            HStack {
                DevicePickerView(
                    selectedDevice: $viewModel.selectedDevice,
                    devices: viewModel.availableDevices,
                    onDeviceSelected: { device in
                        viewModel.selectDevice(device)
                    }
                )

                Spacer()

                if viewModel.isRecording {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)

                        Text(TimeFormatter.formatTimecode(viewModel.recordingDuration))
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))

            // Live preview area
            ZStack {
                Color.black

                if let previewLayer = viewModel.previewLayer {
                    LivePreviewView(previewLayer: previewLayer)
                        .aspectRatio(4/3, contentMode: .fit)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "video.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)

                        if viewModel.availableDevices.isEmpty {
                            Text("No capture device found")
                                .font(.title3)
                                .foregroundColor(.secondary)

                            Text("Connect a USB video capture device")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Select a device to begin")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            // Bottom controls
            VStack(spacing: 16) {
                // Recording button
                Button(action: {
                    viewModel.toggleRecording()
                }) {
                    HStack {
                        Image(systemName: viewModel.isRecording ? "stop.fill" : "record.circle")
                        Text(viewModel.isRecording ? "Stop Recording" : "Start Recording")
                    }
                    .frame(minWidth: 160)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(viewModel.selectedDevice == nil || !viewModel.isSessionRunning)
                .tint(viewModel.isRecording ? .red : .blue)

                if !viewModel.isSessionRunning && viewModel.selectedDevice != nil {
                    Text("Initializing capture session...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.showError = false
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
        .task {
            await viewModel.setupCaptureSession()
        }
    }
}

#Preview {
    CaptureView()
        .frame(width: 900, height: 600)
}
