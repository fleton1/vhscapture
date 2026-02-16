//
//  ProgressView.swift
//  VHSCapture
//
//  Export progress indicator
//

import SwiftUI

struct ExportProgressView: View {
    let progress: Double
    let isExporting: Bool

    var body: some View {
        VStack(spacing: 12) {
            ProgressView(value: progress)
                .progressViewStyle(.linear)

            HStack {
                Text("Exporting: \(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                if isExporting {
                    ProgressView()
                        .controlSize(.small)
                }
            }
        }
    }
}
