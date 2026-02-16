//
//  DevicePickerView.swift
//  VHSCapture
//
//  USB device selection picker
//

import SwiftUI

struct DevicePickerView: View {
    @Binding var selectedDevice: CaptureDevice?
    let devices: [CaptureDevice]
    let onDeviceSelected: (CaptureDevice) -> Void

    var body: some View {
        HStack {
            Image(systemName: "video.fill")
                .foregroundColor(.secondary)

            Picker("Device", selection: $selectedDevice) {
                if devices.isEmpty {
                    Text("No devices found").tag(nil as CaptureDevice?)
                } else {
                    ForEach(devices) { device in
                        Text(device.name).tag(device as CaptureDevice?)
                    }
                }
            }
            .pickerStyle(.menu)
            .frame(minWidth: 250)
            .onChange(of: selectedDevice) { oldValue, newValue in
                if let device = newValue {
                    onDeviceSelected(device)
                }
            }

            Button(action: {
                // Refresh device list
            }) {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(.borderless)
            .help("Refresh device list")
        }
    }
}
