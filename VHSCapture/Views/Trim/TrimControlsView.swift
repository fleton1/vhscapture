//
//  TrimControlsView.swift
//  VHSCapture
//
//  Playback controls for trim view
//

import SwiftUI

struct TrimControlsView: View {
    @ObservedObject var viewModel: TrimViewModel

    var body: some View {
        HStack(spacing: 20) {
            // Jump to trim start
            Button(action: {
                viewModel.seekToTrimStart()
            }) {
                Image(systemName: "backward.end.fill")
            }
            .help("Jump to trim start")

            // Play/Pause
            Button(action: {
                viewModel.togglePlayback()
            }) {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title2)
            }
            .buttonStyle(.borderedProminent)
            .help(viewModel.isPlaying ? "Pause" : "Play")

            // Jump to trim end
            Button(action: {
                viewModel.seekToTrimEnd()
            }) {
                Image(systemName: "forward.end.fill")
            }
            .help("Jump to trim end")

            Divider()
                .frame(height: 20)

            // Set trim markers
            Button(action: {
                viewModel.setTrimStart()
            }) {
                HStack {
                    Image(systemName: "scissors")
                    Text("Set Start")
                }
            }
            .help("Set trim start point (I)")

            Button(action: {
                viewModel.setTrimEnd()
            }) {
                HStack {
                    Image(systemName: "scissors")
                    Text("Set End")
                }
            }
            .help("Set trim end point (O)")
        }
        .buttonStyle(.bordered)
    }
}
