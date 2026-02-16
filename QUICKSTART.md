# Quick Start Guide

Get VHS Capture running in 5 minutes.

## Prerequisites

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later
- (Optional) USB video capture device

## Build Steps

### 1. Create Xcode Project

```bash
# Open Xcode and create a new project:
# File → New → Project → macOS → App
```

**Settings:**
- Product Name: `VHSCapture`
- Interface: `SwiftUI`
- Language: `Swift`
- Minimum Deployment: `macOS 13.0`

### 2. Add Source Files

In Xcode:
1. Delete default `ContentView.swift` and `VHSCaptureApp.swift`
2. Right-click project → "Add Files to VHSCapture..."
3. Select the entire `VHSCapture` folder from this repository
4. **Uncheck** "Copy items if needed"
5. Click "Add"

### 3. Configure Permissions

In Xcode, select your project → Target → Info tab, add:

| Key | Value |
|-----|-------|
| `NSCameraUsageDescription` | VHS Capture needs camera access to connect to your USB video capture device. |
| `NSMicrophoneUsageDescription` | VHS Capture needs microphone access to record audio from your capture device. |

### 4. Build and Run

Press `⌘R` or click the Run button.

## First Launch

1. **Grant Permissions** - Allow camera and microphone access when prompted
2. **Connect Device** - Plug in USB capture device (or use built-in camera for testing)
3. **Select Device** - Choose from dropdown in capture view
4. **Start Recording** - Click "Start Recording" button

## Test Workflow

### Full Capture-to-Export Test

1. **Capture** (30 seconds)
   - Click "Start Recording"
   - Wait 30 seconds
   - Click "Stop Recording"
   - App auto-navigates to Trim view

2. **Trim** (30 seconds)
   - Drag timeline handles to select portion
   - Or use "Set Start" / "Set End" buttons
   - Click "Apply Trim"
   - Wait for processing
   - App auto-navigates to Export view

3. **Export** (1-2 minutes)
   - Choose codec (H.264 or H.265)
   - Adjust quality slider
   - Click "Export..."
   - Choose save location
   - Wait for export to complete
   - File opens in Finder automatically

**Total time**: ~3-4 minutes for complete workflow

## Troubleshooting

### No devices found
- Check USB connections
- Try unplugging and replugging device
- Install device drivers if needed
- Restart app

### Permissions denied
- Open System Settings → Privacy & Security
- Enable Camera and Microphone for VHSCapture
- Restart app

### Build errors
- Ensure all files are added to target (check File Inspector)
- Clean build folder: Product → Clean Build Folder (⇧⌘K)
- Restart Xcode

### Preview is black
- Check video source is powered on and playing
- Verify cable connections
- USB capture has normal 0.5-1s delay

## Next Steps

Once basic functionality works:

1. ✅ Test with actual VHS tapes
2. ✅ Test long recordings (1+ hour)
3. ✅ Test both H.264 and H.265 export
4. ✅ Test all trim controls
5. ✅ Review all preferences

## Resources

- **Full Documentation**: See [README.md](README.md)
- **Detailed Setup**: See [SETUP.md](SETUP.md)
- **Project Overview**: See [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)
- **Known Issues**: See [TODO.md](TODO.md)

## Support

For issues:
1. Check [TODO.md](TODO.md) for known issues
2. Review [SETUP.md](SETUP.md) troubleshooting section
3. Verify hardware compatibility
4. Check macOS version compatibility

---

**Time to first recording**: < 5 minutes
**Time to first export**: < 10 minutes

Happy capturing! 🎬
