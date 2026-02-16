# CLAUDE.md - AI Assistant Guide

This file provides context and guidelines for AI assistants working on the VHS Capture project.

## Project Overview

**VHS Capture** is a modern macOS application for USB video capture and VHS digitization, built with Swift and SwiftUI. The app enables users to capture video from USB devices, trim recordings, and export in multiple formats (H.264, H.265/HEVC).

## Architecture

### Design Pattern: MVVM + Coordinator
- **Models**: Data structures and business entities
- **ViewModels**: State management with Combine publishers
- **Views**: SwiftUI declarative UI components
- **Services**: Platform integration (AVFoundation, file system)
- **Coordinator**: Workflow state management in ContentView

### Key Technologies
- **SwiftUI** - UI framework
- **AVFoundation** - Video capture, processing, export
- **AVKit** - Video playback
- **Combine** - Reactive programming
- **CoreMedia** - Time manipulation

## Project Structure

```
VHSCapture/
├── VHSCaptureApp.swift           # @main entry point
├── Models/                        # Data models (4 files)
├── ViewModels/                    # State management (3 files)
├── Views/                         # SwiftUI views (15 files)
│   ├── MainWindow/               # Navigation & preferences
│   ├── Capture/                  # Recording interface
│   ├── Trim/                     # Timeline & trimming
│   ├── Export/                   # Format conversion
│   └── Library/                  # Recordings list
├── Services/                      # Business logic (4 files)
└── Utilities/                     # Helpers (2 files)
```

## Development Guidelines

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftUI view composition patterns
- Leverage Combine for reactive data flow
- Maintain MVVM separation of concerns
- Use `@MainActor` for UI-bound ViewModels
- Prefer value types (struct) over reference types (class)

### Naming Conventions
- **Models**: Nouns (e.g., `VideoRecording`, `CaptureDevice`)
- **ViewModels**: Suffixed with `ViewModel` (e.g., `CaptureViewModel`)
- **Views**: Suffixed with `View` (e.g., `CaptureView`, `TimelineView`)
- **Services**: Suffixed with `Service` (e.g., `CaptureService`)

### State Management
- Use `@Published` in ViewModels for observable state
- Use `@StateObject` for ViewModel ownership in Views
- Use `@ObservedObject` when passing ViewModels between views
- Use `@State` for local view-only state
- Use `@AppStorage` for user preferences persistence

### Error Handling
- Use Swift's typed errors (`Error` protocol)
- Provide user-friendly error messages
- Show alerts for user-facing errors
- Log technical details for debugging
- Never crash on recoverable errors

### Testing Strategy
- Manual testing with physical USB capture devices
- Test all codecs (H.264, H.265)
- Test edge cases (empty library, very long recordings)
- Verify memory management (no leaks)
- Test permissions flow

## Common Tasks

### Adding a New Feature

1. **Plan the architecture**
   - Determine which layer (Model/ViewModel/View/Service)
   - Consider state management approach
   - Plan notification/coordination mechanism

2. **Implement bottom-up**
   - Start with Model (if needed)
   - Create/update Service
   - Build ViewModel
   - Create View
   - Wire up in ContentView

3. **Test thoroughly**
   - Test happy path
   - Test error cases
   - Test edge cases
   - Verify memory management

### Modifying Capture Logic

The capture flow:
1. `DeviceDiscoveryService` - Discovers USB devices
2. `CaptureService` - Manages AVCaptureSession
3. `CaptureViewModel` - Coordinates UI and service
4. `CaptureView` - Displays preview and controls

**Key files:**
- `Services/CaptureService.swift` - AVFoundation wrapper
- `ViewModels/CaptureViewModel.swift` - State management
- `Views/Capture/CaptureView.swift` - UI

### Modifying Trim/Export Logic

Trim flow:
1. `TrimViewModel` - Manages timeline state and playback
2. `VideoProcessingService` - Performs trim operation
3. `TrimView` - Timeline UI and controls

Export flow:
1. `ExportViewModel` - Manages export settings
2. `ExportService` - Performs export with AVAssetExportSession
3. `ExportView` - Settings UI and progress

## Important Patterns

### Notification-Based Coordination

The app uses NotificationCenter for loose coupling:

```swift
// Post notification
NotificationCenter.default.post(
    name: .recordingDidFinish,
    object: nil,
    userInfo: ["url": outputURL]
)

// Listen for notification
NotificationCenter.default.publisher(for: .recordingDidFinish)
    .sink { notification in
        // Handle event
    }
    .store(in: &cancellables)
```

**Key notifications:**
- `.recordingDidFinish` - Recording completed
- `.newRecordingCreated` - New recording added to library
- `.trimCompleted` - Trim operation finished

### AVFoundation Integration

**Capture Session Setup:**
```swift
let session = AVCaptureSession()
let device = AVCaptureDevice.default(for: .video)
let input = try AVCaptureDeviceInput(device: device)
session.addInput(input)
session.startRunning()
```

**Video Export:**
```swift
let exportSession = AVAssetExportSession(asset: asset, presetName: .highestQuality)
exportSession.outputURL = outputURL
exportSession.outputFileType = .mp4
await exportSession.export()
```

### Time Formatting

Use `TimeFormatter` utility for consistent time display:
- `formatTimecode(_:)` - HH:MM:SS format
- `formatDuration(_:)` - Compact format (1h 23m)
- `formatFileSize(_:)` - Human-readable bytes

## Debugging Tips

### AVFoundation Issues
- Check permissions: System Settings → Privacy & Security
- Verify device compatibility with `AVCaptureDevice.DiscoverySession`
- Monitor session state with `session.isRunning`
- Check for errors in `AVCaptureFileOutputRecordingDelegate`

### SwiftUI Preview Issues
- Some views require AVFoundation setup (won't work in preview)
- Use conditional compilation: `#if DEBUG`
- Test with full app build instead

### Memory Issues
- Use Instruments to detect leaks
- Verify `weak self` in closures
- Release AVPlayer resources when done
- Clean up NotificationCenter observers

## File Locations

### Runtime Storage
- **Recordings**: `~/Library/Application Support/VHSCapture/Recordings/`
- **Temporary**: `~/Library/Caches/TemporaryItems/VHSCapture/`
- **Preferences**: `~/Library/Preferences/com.vhscapture.app.plist`

### Build Artifacts
- **Xcode Build**: `build/DerivedData/`
- **DMG Output**: `dmg/`
- **Archives**: `Archives/`

## Known Limitations

1. **No thumbnail generation** - Library shows placeholder icons
2. **No deinterlacing** - VHS interlaced content not processed
3. **Single window** - No multi-window support
4. **No batch operations** - One recording at a time
5. **Fixed aspect ratio** - Assumes 4:3 aspect ratio

See `TODO.md` for planned enhancements.

## External Dependencies

**Zero** - The app uses only Apple frameworks:
- Foundation
- SwiftUI
- AVFoundation
- AVKit
- Combine
- CoreMedia
- AppKit (for NSSavePanel, NSWorkspace)

## Platform Requirements

- **Minimum**: macOS 13.0 (Ventura)
- **Recommended**: macOS 14.0+ (Sonoma) for best performance
- **Architecture**: Universal (arm64 + x86_64)

## Build & Release Process

1. **Build app**: `./scripts/build.sh`
2. **Create DMG**: `./scripts/create-dmg.sh`
3. **Notarize** (optional): `./scripts/notarize.sh dmg/VHSCapture-1.0.0.dmg`
4. **Create release**: `gh release create v1.0.0 dmg/VHSCapture-1.0.0.dmg`

See `SETUP.md` for detailed build instructions.

## Contributing Guidelines

When making changes:
1. Follow existing code style and patterns
2. Update documentation if changing architecture
3. Test with physical hardware when possible
4. Update CHANGELOG.md with changes
5. Maintain backward compatibility when possible

## Resources

- **Apple Docs**: https://developer.apple.com/documentation/
- **AVFoundation Guide**: https://developer.apple.com/av-foundation/
- **SwiftUI Tutorials**: https://developer.apple.com/tutorials/swiftui

## Questions to Ask

When working on this project, consider:
- Does this maintain the MVVM architecture?
- Is state management clear and testable?
- Are errors handled gracefully?
- Will this work with all supported USB devices?
- Is the UI intuitive and accessible?
- Does this impact memory usage significantly?
- Should this be configurable in preferences?

---

**Last Updated**: 2024-02-16
**Version**: 1.0.0
**Maintainer**: VHS Capture Project
