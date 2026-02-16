# Changelog

All notable changes to VHS Capture will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### To Be Added
- Video thumbnail generation for library view
- Audio level monitoring during capture
- Deinterlacing filter for VHS content
- Keyboard shortcuts (Space, I, O, ⌘R)
- Custom app icon

## [1.0.0] - 2024-02-16

### Added - Phase 1: Basic Capture
- USB video capture device discovery
- Live video preview with AVCaptureVideoPreviewLayer
- Video recording with AVCaptureSession
- Device selection dropdown interface
- Recording duration timer
- Permission handling for camera and microphone

### Added - Phase 2: Playback & File Management
- VideoRecording model with metadata
- File storage in Application Support directory
- Recordings library view with list display
- Context menu actions (Show in Finder, Delete)
- File size and duration display
- Relative date formatting

### Added - Phase 3: Video Trimming
- Timeline view with visual scrubber
- Draggable trim start/end handles
- Playback controls (play/pause, jump to markers)
- Set trim markers at current position buttons
- Apply trim operation with background processing
- Real-time trim duration calculation
- Progress tracking during trim operation

### Added - Phase 4: Export & Conversion
- Codec selection (H.264, H.265/HEVC)
- Quality slider (30% - 100%)
- Resolution options (Original, 1080p, 720p, 480p)
- Export progress tracking with percentage
- NSSavePanel integration for save location
- Estimated file size calculation
- Show in Finder after successful export
- Cancel export functionality

### Added - Phase 5: Navigation & Workflow
- ContentView with workflow state machine
- AppToolbar with segmented navigation control
- Auto-navigation after capture → trim → export
- Notification-based coordination between views
- Library view with recording selection
- Back navigation support

### Added - Phase 6: Polish & Error Handling
- Error alerts throughout the application
- Permission request handling
- Preferences window with three tabs:
  - General: Default codec and quality settings
  - Storage: File location management
  - About: App information and credits
- File cleanup utilities (7-day auto-cleanup)
- User feedback for all operations
- Settings persistence with @AppStorage
- Empty states for library and capture views

### Technical
- MVVM + Coordinator architecture pattern
- SwiftUI declarative UI throughout
- Combine for reactive data binding
- AVFoundation for video capture and processing
- AVKit for video playback
- CoreMedia for time manipulation
- Comprehensive error handling
- Background processing for long operations
- Automatic memory management

## Version History

- **1.0.0** - Initial release (2024-02-16)
  - Complete implementation of all 6 phases
  - Full capture, trim, and export workflow
  - Modern SwiftUI interface
  - macOS 13.0+ support

---

## Future Versions

### [1.1.0] - Planned
- Video thumbnail generation
- Audio level monitoring
- Deinterlacing filter
- Complete keyboard shortcut support
- App icon and branding

### [1.2.0] - Planned
- Batch export operations
- Enhanced metadata editing
- Scene detection
- Chapter markers
- Timeline thumbnails

### [2.0.0] - Long-term
- Advanced video filters
- Cloud backup integration
- Multi-window support
- Plugin architecture
- Advanced color correction

---

## Notes

- Each version bump follows semantic versioning
- Breaking changes will increment major version
- New features increment minor version
- Bug fixes increment patch version
