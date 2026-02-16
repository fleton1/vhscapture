//
//  LivePreviewView.swift
//  VHSCapture
//
//  NSViewRepresentable wrapper for AVCaptureVideoPreviewLayer
//

import SwiftUI
import AVFoundation

struct LivePreviewView: NSViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer?

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor

        if let layer = previewLayer {
            layer.videoGravity = .resizeAspect
            layer.frame = view.bounds
            view.layer?.addSublayer(layer)
        }

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        if let layer = previewLayer {
            layer.frame = nsView.bounds
        }
    }
}
