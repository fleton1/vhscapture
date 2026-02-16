#!/bin/bash
# Build script for VHS Capture
# Builds the macOS app from Xcode project

set -e

echo "🔨 Building VHS Capture..."

# Configuration
PROJECT_NAME="VHSCapture"
SCHEME_NAME="VHSCapture"
CONFIGURATION="Release"
BUILD_DIR="build"
PRODUCT_NAME="VHS Capture.app"

# Check if Xcode project exists
if [ ! -f "${PROJECT_NAME}.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: Xcode project not found!"
    echo "Please create an Xcode project first. See SETUP.md for instructions."
    exit 1
fi

# Clean build directory
echo "🧹 Cleaning build directory..."
rm -rf "${BUILD_DIR}"

# Build the app
echo "🏗️  Building application..."
xcodebuild \
    -project "${PROJECT_NAME}.xcodeproj" \
    -scheme "${SCHEME_NAME}" \
    -configuration "${CONFIGURATION}" \
    -derivedDataPath "${BUILD_DIR}/DerivedData" \
    -arch arm64 -arch x86_64 \
    clean build

# Find the built app
APP_PATH="${BUILD_DIR}/DerivedData/Build/Products/${CONFIGURATION}/${PRODUCT_NAME}"

if [ ! -d "$APP_PATH" ]; then
    echo "❌ Error: Build failed! App not found at: $APP_PATH"
    exit 1
fi

echo "✅ Build complete!"
echo "📦 App located at: $APP_PATH"
echo ""
echo "Next steps:"
echo "  - Run: ./scripts/create-dmg.sh to create installer"
echo "  - Or run: open \"$APP_PATH\" to test the app"
