# Building on macOS

This guide is for building VHS Capture on a Mac to create the DMG installer.

## Prerequisites

- Mac with macOS 13.0 (Ventura) or later
- Xcode 15.0 or later installed
- Command Line Tools installed

## Step-by-Step Build Process

### 1. Clone Repository

```bash
git clone https://github.com/fleton1/vhscapture.git
cd vhscapture
```

### 2. Create Xcode Project

**Option A: Using Xcode GUI (Recommended)**

1. Open Xcode
2. File → New → Project
3. Select **macOS** → **App**
4. Configure:
   - Product Name: `VHSCapture`
   - Team: Select your development team
   - Organization Identifier: `com.vhscapture`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: None
   - Click "Next"
5. Save in the `vhscapture` directory (same level as the VHSCapture folder)

6. **Add Source Files:**
   - Delete the default `ContentView.swift` and `VHSCaptureApp.swift` that Xcode created
   - In Project Navigator, right-click on `VHSCapture` → "Add Files to VHSCapture..."
   - Navigate to and select the entire `VHSCapture` folder from the cloned repo
   - **IMPORTANT**: Uncheck "Copy items if needed"
   - Check "Create groups"
   - Click "Add"

7. **Configure Info.plist:**
   - Select project in navigator → Select target → "Info" tab
   - Click "+" to add new entries:
     - Key: `NSCameraUsageDescription`
       Value: `VHS Capture needs camera access to connect to your USB video capture device.`
     - Key: `NSMicrophoneUsageDescription`
       Value: `VHS Capture needs microphone access to record audio from your capture device.`

8. **Set Deployment Target:**
   - General tab → Deployment Info → macOS 13.0

9. **Build Settings (if needed):**
   - Signing: Select your development team
   - Or for local testing: Signing & Capabilities → Signing → "Sign to Run Locally"

**Option B: Using Command Line**

```bash
# This creates a basic structure, but GUI method is more reliable
xcodegen generate  # If you have xcodegen installed
# Then follow steps 6-9 above in Xcode
```

### 3. Build the Application

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Build (creates release build with universal binary)
./scripts/build.sh
```

This will create:
```
build/DerivedData/Build/Products/Release/VHS Capture.app
```

### 4. Test the App

```bash
# Run the built app
open "build/DerivedData/Build/Products/Release/VHS Capture.app"
```

Test basic functionality:
- App launches
- Permissions prompts appear
- USB device detection works (if you have one)
- UI is responsive

### 5. Create DMG Installer

```bash
./scripts/create-dmg.sh
```

This creates:
```
dmg/VHSCapture-1.0.0.dmg
```

### 6. Test the DMG

```bash
# Mount and test the DMG
open dmg/VHSCapture-1.0.0.dmg
```

- Verify the DMG opens
- Drag app to Applications (symlink should work)
- Launch from Applications folder
- Verify it runs correctly

### 7. Upload to GitHub Release

```bash
# Upload DMG to the existing draft release
gh release upload v1.0.0 dmg/VHSCapture-1.0.0.dmg

# Publish the release
gh release edit v1.0.0 --draft=false
```

Or upload manually:
1. Go to https://github.com/fleton1/vhscapture/releases
2. Edit the v1.0.0 draft release
3. Drag and drop the DMG file
4. Click "Publish release"

## Optional: Code Signing and Notarization

For distribution outside the App Store (recommended for public release):

### Code Signing

Already happens automatically if you have a Developer account selected in Xcode.

### Notarization

```bash
# Set up environment variables
export NOTARIZE_APPLE_ID="your-apple-id@example.com"
export NOTARIZE_TEAM_ID="YOUR_TEAM_ID"
export NOTARIZE_APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"

# Notarize the DMG
./scripts/notarize.sh dmg/VHSCapture-1.0.0.dmg
```

To create an app-specific password:
1. Go to https://appleid.apple.com
2. Sign in
3. Security section → App-Specific Passwords
4. Generate new password

## Troubleshooting

### Build Fails

**Error**: "Command PhaseScriptExecution failed"
- Clean build folder: Product → Clean Build Folder (⇧⌘K)
- Restart Xcode

**Error**: "No signing identity found"
- Xcode → Preferences → Accounts → Add your Apple ID
- Or: Build Settings → Signing → Sign to Run Locally

### Files Not Found

**Error**: "No such file or directory"
- Verify all files are added to the target (check File Inspector)
- Verify Info.plist is in the correct location

### App Crashes on Launch

- Check Console.app for crash logs
- Verify permissions are in Info.plist
- Test with Xcode debugger (⌘R)

### DMG Creation Fails

**Error**: "App not found"
- Verify build succeeded first
- Check path: `build/DerivedData/Build/Products/Release/VHS Capture.app`

## Alternative: Build with Swift Package Manager

**Note**: This might not work perfectly for SwiftUI apps that need entitlements and Info.plist.

```bash
swift build -c release
```

But you'll likely need the full Xcode project for proper macOS app building.

## Estimated Time

- First-time setup: 15-30 minutes
- Build time: 2-5 minutes
- DMG creation: 1-2 minutes
- Total: ~20-40 minutes

## Files Generated

After successful build:
```
vhscapture/
├── VHSCapture.xcodeproj/          # Xcode project (commit this!)
├── build/                          # Build artifacts (ignored by git)
│   └── DerivedData/
│       └── Build/Products/Release/
│           └── VHS Capture.app    # The built application
├── dmg/                            # DMG output (ignored by git)
│   └── VHSCapture-1.0.0.dmg       # Installer
└── [source files...]
```

## Next Steps After Building

1. ✅ Test the app thoroughly
2. ✅ Upload DMG to GitHub release
3. ✅ Publish the release
4. ✅ (Optional) Commit VHSCapture.xcodeproj to git
5. ✅ (Optional) Set up GitHub Actions for automated builds

## Need Help?

- **Build issues**: Check [SETUP.md](SETUP.md)
- **App issues**: Check the TODO.md known issues
- **Questions**: Open an issue on GitHub

---

**Once you've built the DMG, upload it to the draft release at:**
https://github.com/fleton1/vhscapture/releases
