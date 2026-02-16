#!/bin/bash
# Create DMG installer for VHS Capture

set -e

echo "📀 Creating DMG installer for VHS Capture..."

# Configuration
APP_NAME="VHS Capture"
PRODUCT_NAME="VHS Capture.app"
DMG_NAME="VHSCapture"
VERSION="1.0.0"
BUILD_DIR="build"
DMG_DIR="dmg"
BACKGROUND_IMAGE="dmg-background.png"

# Paths
APP_PATH="${BUILD_DIR}/DerivedData/Build/Products/Release/${PRODUCT_NAME}"
DMG_TEMP="${DMG_DIR}/temp"
DMG_OUTPUT="${DMG_DIR}/${DMG_NAME}-${VERSION}.dmg"

# Check if app exists
if [ ! -d "$APP_PATH" ]; then
    echo "❌ Error: App not found at: $APP_PATH"
    echo "Please run ./scripts/build.sh first"
    exit 1
fi

# Create DMG directory
echo "📁 Setting up DMG directory..."
rm -rf "${DMG_DIR}"
mkdir -p "${DMG_TEMP}"

# Copy app to DMG temp directory
echo "📋 Copying application..."
cp -R "$APP_PATH" "${DMG_TEMP}/"

# Create Applications symlink
echo "🔗 Creating Applications symlink..."
ln -s /Applications "${DMG_TEMP}/Applications"

# Create README for DMG
echo "📝 Creating DMG README..."
cat > "${DMG_TEMP}/README.txt" << EOF
VHS Capture - macOS Video Capture Application
Version ${VERSION}

Installation:
1. Drag "VHS Capture.app" to the Applications folder
2. Launch from Applications or Spotlight
3. Grant camera and microphone permissions when prompted

Requirements:
- macOS 13.0 (Ventura) or later
- USB video capture device (optional for testing)

Support:
- Documentation: https://github.com/yourusername/vhscapture
- Issues: https://github.com/yourusername/vhscapture/issues

© 2024 VHS Capture
Licensed under MIT License
EOF

# Calculate DMG size
echo "📏 Calculating DMG size..."
SIZE=$(du -sm "${DMG_TEMP}" | awk '{print $1}')
SIZE=$((SIZE + 50)) # Add 50MB padding

# Create DMG
echo "💿 Creating disk image..."
hdiutil create \
    -volname "${APP_NAME}" \
    -srcfolder "${DMG_TEMP}" \
    -ov \
    -format UDZO \
    -size ${SIZE}m \
    "${DMG_OUTPUT}"

# Clean up
echo "🧹 Cleaning up..."
rm -rf "${DMG_TEMP}"

# Get DMG info
DMG_SIZE=$(du -h "${DMG_OUTPUT}" | awk '{print $1}')

echo ""
echo "✅ DMG created successfully!"
echo "📦 Location: ${DMG_OUTPUT}"
echo "📊 Size: ${DMG_SIZE}"
echo ""
echo "To test the DMG:"
echo "  open ${DMG_OUTPUT}"
echo ""
echo "To create a GitHub release:"
echo "  gh release create v${VERSION} ${DMG_OUTPUT} --title \"VHS Capture v${VERSION}\" --notes \"See CHANGELOG.md\""
