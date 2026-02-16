//
//  TimelineView.swift
//  VHSCapture
//
//  Timeline scrubber with draggable trim handles
//

import SwiftUI

struct TimelineView: View {
    @ObservedObject var viewModel: TrimViewModel
    @State private var isDraggingPlayhead = false
    @State private var isDraggingStart = false
    @State private var isDraggingEnd = false

    private let handleWidth: CGFloat = 12
    private let timelineHeight: CGFloat = 60

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(nsColor: .controlBackgroundColor))

                // Trimmed region highlight
                let startX = xPosition(for: viewModel.trimStart, width: geometry.size.width)
                let endX = xPosition(for: viewModel.trimEnd, width: geometry.size.width)

                Rectangle()
                    .fill(Color.accentColor.opacity(0.2))
                    .frame(width: max(0, endX - startX))
                    .offset(x: startX)

                // Playhead
                let playheadX = xPosition(for: viewModel.currentTime, width: geometry.size.width)
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2)
                    .offset(x: playheadX)

                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .offset(x: playheadX - 6, y: -timelineHeight / 2 - 10)

                // Trim start handle
                TrimHandle(isStart: true)
                    .offset(x: startX - handleWidth / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isDraggingStart = true
                                let newTime = timeForPosition(value.location.x + startX, width: geometry.size.width)
                                viewModel.updateTrimStart(newTime)
                            }
                            .onEnded { _ in
                                isDraggingStart = false
                            }
                    )

                // Trim end handle
                TrimHandle(isStart: false)
                    .offset(x: endX - handleWidth / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isDraggingEnd = true
                                let newTime = timeForPosition(value.location.x + endX, width: geometry.size.width)
                                viewModel.updateTrimEnd(newTime)
                            }
                            .onEnded { _ in
                                isDraggingEnd = false
                            }
                    )
            }
            .frame(height: timelineHeight)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDraggingPlayhead = true
                        let time = timeForPosition(value.location.x, width: geometry.size.width)
                        viewModel.seek(to: time)
                    }
                    .onEnded { _ in
                        isDraggingPlayhead = false
                    }
            )
        }
    }

    private func xPosition(for time: TimeInterval, width: CGFloat) -> CGFloat {
        let fraction = time / viewModel.recording.duration
        return fraction * width
    }

    private func timeForPosition(_ x: CGFloat, width: CGFloat) -> TimeInterval {
        let fraction = x / width
        return fraction * viewModel.recording.duration
    }
}

struct TrimHandle: View {
    let isStart: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.accentColor)
            .frame(width: 12, height: 60)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 2)
    }
}
