# VHS Capture

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13.0+-blue.svg" alt="macOS 13.0+">
  <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift 5.9">
  <img src="https://img.shields.io/badge/SwiftUI-✓-green.svg" alt="SwiftUI">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License">
  <img src="https://img.shields.io/github/v/release/yourusername/vhscapture" alt="Release">
</p>

<p align="center">
  A modern macOS application for USB video capture and VHS digitization.
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#building">Building</a> •
  <a href="#contributing">Contributing</a>
</p>

---

## Features

- **USB Video Capture** - Connect any AVFoundation-compatible USB capture device
- **Live Preview** - Real-time video preview during capture
- **Video Trimming** - Intuitive timeline-based trimming interface
- **Format Conversion** - Export to MP4 with H.264 or H.265/HEVC codecs
- **Modern UI** - Clean, simple SwiftUI interface
- **macOS Native** - Built with Swift and AVFoundation

## Installation

### Download Pre-built Release

1. Download the latest `.dmg` file from [Releases](https://github.com/yourusername/vhscapture/releases)
2. Open the DMG and drag **VHS Capture** to your Applications folder
3. Launch from Applications or Spotlight
4. Grant camera and microphone permissions when prompted

### Build from Source

See the [Building](#building-the-project) section below.

## Requirements

- macOS 13.0 (Ventura) or later
- USB video capture device (Elgato, Blackmagic, generic USB capture dongles)
- Xcode 15.0+ (for building from source)

## Building the Project

### Quick Build

```bash
# Clone the repository
git clone https://github.com/yourusername/vhscapture.git
cd vhscapture

# Build the app (requires Xcode project setup first - see SETUP.md)
./scripts/build.sh

# Create DMG installer
./scripts/create-dmg.sh
```

For detailed build instructions, see [SETUP.md](SETUP.md).

### Option 1: Using Xcode

1. Open Xcode
2. Create a new macOS App project:
   - Product Name: `VHSCapture`
   - Interface: SwiftUI
   - Language: Swift
   - Minimum Deployment: macOS 13.0
3. Copy all files from the `VHSCapture` directory into your Xcode project:
   - Add all `.swift` files to the project
   - Add `Info.plist` to the project
4. Configure project settings:
   - Set the bundle identifier: `com.vhscapture.app`
   - Set deployment target: macOS 13.0
   - Enable App Sandbox capabilities if needed
5. Build and run (⌘R)

### Option 2: Using Swift Package Manager (CLI)

Create a `Package.swift` file in the project root:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VHSCapture",
    platforms: [.macOS(.v13)],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "VHSCapture",
            path: "VHSCapture"
        )
    ]
)
```

Then build:

```bash
swift build
swift run VHSCapture
```

## Project Structure

```
VHSCapture/
├── VHSCaptureApp.swift              # App entry point
├── Models/                          # Data models
│   ├── CaptureDevice.swift          # USB device representation
│   ├── VideoRecording.swift         # Recording metadata
│   ├── VideoProject.swift           # Project management
│   └── ExportSettings.swift         # Export configuration
├── ViewModels/                      # MVVM view models
│   ├── CaptureViewModel.swift       # Capture state management
│   ├── TrimViewModel.swift          # Trimming logic
│   └── ExportViewModel.swift        # Export logic
├── Views/                           # SwiftUI views
│   ├── MainWindow/                  # Main window & navigation
│   ├── Capture/                     # Capture interface
│   ├── Trim/                        # Trimming interface
│   ├── Export/                      # Export interface
│   └── Library/                     # Recordings library
├── Services/                        # Business logic
│   ├── CaptureService.swift         # AVCapture wrapper
│   ├── VideoProcessingService.swift # Trimming operations
│   ├── ExportService.swift          # Export operations
│   └── DeviceDiscoveryService.swift # USB device discovery
└── Utilities/                       # Helper utilities
    ├── TimeFormatter.swift          # Time formatting
    └── FileManager+Extensions.swift # File management
```

## Usage

### 1. Capture Video

1. Connect your USB video capture device
2. Select the device from the dropdown menu
3. Click "Start Recording" to begin capture
4. Click "Stop Recording" when finished

### 2. Trim Video

After recording:
1. The trim view opens automatically
2. Use the timeline to scrub through the video
3. Drag the trim handles to set start/end points
4. Or use "Set Start" and "Set End" buttons at current position
5. Click "Apply Trim" to create the trimmed version

### 3. Export Video

After trimming:
1. The export view opens automatically
2. Choose codec (H.264 or H.265/HEVC)
3. Adjust quality slider
4. Select resolution if needed
5. Click "Export..." to choose save location
6. Wait for export to complete

### Keyboard Shortcuts

- **Space** - Play/Pause (in trim view)
- **I** - Set trim in point
- **O** - Set trim out point
- **⌘R** - Start/Stop recording (planned)

## Storage

- **Recordings**: `~/Library/Application Support/VHSCapture/Recordings/`
- **Temporary files**: `~/Library/Caches/TemporaryItems/VHSCapture/`

Temporary files are automatically cleaned up after 7 days.

## Supported Devices

This app works with any USB video capture device that is compatible with macOS AVFoundation:

- Elgato Video Capture
- Blackmagic capture cards
- Generic USB capture dongles
- USB HDMI capture devices

**Note**: Some devices may require manufacturer-specific drivers to be installed first.

## Troubleshooting

### No device detected

1. Ensure the USB capture device is properly connected
2. Check that any required drivers are installed
3. Grant camera and microphone permissions when prompted
4. Try clicking the refresh button next to the device picker

### Preview shows black screen

1. Check that your video source (VCR, etc.) is powered on and playing
2. Verify cables are properly connected
3. Some devices have a slight delay in preview (~0.5-1s is normal)

### Recording fails to start

1. Ensure you've granted camera and microphone permissions
2. Check available disk space
3. Try restarting the app
4. Disconnect and reconnect the USB device

### Export is very slow

- H.265/HEVC encoding is CPU-intensive
- Older Macs may take longer to encode
- Hardware acceleration is used when available
- Consider using H.264 for faster exports

## Architecture

- **Pattern**: MVVM + Coordinator
- **Frameworks**: AVFoundation, AVKit, SwiftUI, Combine
- **Target**: macOS 13.0+
- **Language**: Swift 5.9+

## Implementation Phases

This project was built in 6 phases:

1. ✅ **Basic Capture** - USB device discovery and recording
2. ✅ **Playback & File Management** - Recording library
3. ✅ **Video Trimming** - Timeline-based trimming
4. ✅ **Export & Conversion** - Codec selection and export
5. ✅ **Navigation & Workflow** - Screen coordination
6. ⏳ **Polish & Error Handling** - Final refinements

## Known Limitations

- No real-time video effects or filters
- Thumbnail generation is basic (placeholder icons)
- No batch processing
- Limited metadata editing
- Single-window interface (no multi-window support)

## Future Enhancements

- Video thumbnail generation from recordings
- Chapter markers
- Batch export multiple recordings
- Audio level monitoring
- Scene detection
- Deinterlacing options
- Custom keyboard shortcuts

## License

This project is provided as-is for educational and personal use.

## Contributing

Contributions are welcome! Please see our contributing guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

For AI assistants working on this project, see [CLAUDE.md](CLAUDE.md) for architecture and development guidelines.

## Roadmap

See [TODO.md](TODO.md) for planned features and enhancements.

## Credits

Built with Swift, SwiftUI, and AVFoundation for macOS 13+.

## Support

- **Documentation**: [README.md](README.md), [SETUP.md](SETUP.md), [QUICKSTART.md](QUICKSTART.md)
- **Issues**: [GitHub Issues](https://github.com/yourusername/vhscapture/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/vhscapture/discussions)
