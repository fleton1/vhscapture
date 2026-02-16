# VHS Capture - Setup Guide

## Quick Start (Xcode)

This is the recommended method for building and running the app.

### Step 1: Create Xcode Project

1. Open Xcode
2. File → New → Project
3. Select macOS → App
4. Configure:
   - Product Name: **VHSCapture**
   - Team: (select your team)
   - Organization Identifier: **com.vhscapture**
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**
   - Click "Next" and choose a location (not this directory)

### Step 2: Add Source Files

1. In Xcode's Project Navigator, delete the default `ContentView.swift` and `VHSCaptureApp.swift` files
2. Right-click on the project and select "Add Files to VHSCapture..."
3. Navigate to this directory's `VHSCapture` folder
4. Select all the Swift files and folders
5. Ensure "Copy items if needed" is **unchecked** (to use files in place)
6. Ensure "Create groups" is selected
7. Click "Add"

### Step 3: Configure Info.plist

1. Select the project in the navigator
2. Select the VHSCapture target
3. Go to the "Info" tab
4. Add custom properties:
   - Right-click and select "Add Row"
   - Key: `NSCameraUsageDescription`
   - Value: `VHS Capture needs camera access to connect to your USB video capture device and display live video preview.`
   - Add another row:
   - Key: `NSMicrophoneUsageDescription`
   - Value: `VHS Capture needs microphone access to record audio from your USB video capture device.`

### Step 4: Build Settings

1. Select the VHSCapture target
2. Go to "General" tab
3. Set "Minimum Deployments" to **macOS 13.0**
4. Go to "Signing & Capabilities" tab
5. Select your development team
6. (Optional) If you need sandbox: Enable "App Sandbox" and check "Camera" and "Audio Input"

### Step 5: Build and Run

1. Connect a USB video capture device (optional for initial testing)
2. Press ⌘R to build and run
3. Grant permissions when prompted
4. The app should launch!

---

## Alternative: Manual Xcode Setup

If you prefer to manually add files:

1. Create new Xcode project as above
2. Create folder groups matching the structure:
   - Models/
   - ViewModels/
   - Views/MainWindow/
   - Views/Capture/
   - Views/Trim/
   - Views/Export/
   - Views/Library/
   - Services/
   - Utilities/
3. Add each Swift file to its corresponding group
4. Follow steps 3-5 above

---

## File Checklist

Ensure all these files are in your Xcode project:

### Root
- [x] VHSCaptureApp.swift

### Models
- [x] CaptureDevice.swift
- [x] VideoRecording.swift
- [x] VideoProject.swift
- [x] ExportSettings.swift

### ViewModels
- [x] CaptureViewModel.swift
- [x] TrimViewModel.swift
- [x] ExportViewModel.swift

### Views/MainWindow
- [x] ContentView.swift
- [x] AppToolbar.swift
- [x] PreferencesView.swift

### Views/Capture
- [x] CaptureView.swift
- [x] LivePreviewView.swift
- [x] DevicePickerView.swift

### Views/Trim
- [x] TrimView.swift
- [x] TimelineView.swift
- [x] TrimControlsView.swift

### Views/Export
- [x] ExportView.swift
- [x] ProgressView.swift

### Views/Library
- [x] LibraryView.swift

### Services
- [x] CaptureService.swift
- [x] DeviceDiscoveryService.swift
- [x] VideoProcessingService.swift
- [x] ExportService.swift

### Utilities
- [x] TimeFormatter.swift
- [x] FileManager+Extensions.swift

---

## Troubleshooting Build Issues

### Missing imports or symbols

- Ensure all files are added to the target (check File Inspector)
- Clean build folder: Product → Clean Build Folder (⇧⌘K)
- Restart Xcode

### Preview crashes

- Some previews may not work without proper AVFoundation setup
- Run the full app instead of using previews for testing

### Signing issues

- Ensure you have a valid Apple Developer account
- Or disable signing: Build Settings → Signing → Code Signing Identity → Sign to Run Locally

### Permissions not showing

- Ensure Info.plist has the camera and microphone usage descriptions
- Delete and reinstall the app if permissions were previously denied

---

## Testing Without Hardware

You can test basic functionality without a USB capture device:

1. The app will detect the built-in camera as a fallback
2. Most UI elements will work
3. Recording and trimming will function normally
4. Export features can be tested with any recorded file

**Note**: For full VHS capture functionality, you need an actual USB video capture device.

---

## Development Tips

### Debugging AVFoundation Issues

Add this to check device discovery:
```swift
print("Available devices: \(CaptureDevice.discoverDevices())")
```

### Testing Export Formats

Export will use hardware acceleration when available. Test both codecs:
- H.264: Faster, wider compatibility
- H.265: Better compression, slower encoding

### Memory Management

Long recordings can consume significant memory. Monitor memory usage in Xcode's Debug Navigator.

---

## Next Steps

Once the app builds successfully:

1. Test with a physical USB capture device
2. Try capturing a short video
3. Test the trimming interface
4. Test export with both H.264 and H.265
5. Review permissions and privacy settings

For issues or enhancements, see the main README.md file.
