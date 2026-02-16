#!/bin/bash
# Notarize the DMG for distribution outside the App Store

set -e

echo "🔐 Notarizing VHS Capture DMG..."

# Configuration
DMG_PATH="$1"
APPLE_ID="${NOTARIZE_APPLE_ID}"
TEAM_ID="${NOTARIZE_TEAM_ID}"
APP_PASSWORD="${NOTARIZE_APP_PASSWORD}" # App-specific password

if [ -z "$DMG_PATH" ]; then
    echo "Usage: $0 <path-to-dmg>"
    exit 1
fi

if [ ! -f "$DMG_PATH" ]; then
    echo "❌ Error: DMG not found: $DMG_PATH"
    exit 1
fi

if [ -z "$APPLE_ID" ] || [ -z "$TEAM_ID" ] || [ -z "$APP_PASSWORD" ]; then
    echo "❌ Error: Missing notarization credentials!"
    echo "Please set the following environment variables:"
    echo "  NOTARIZE_APPLE_ID - Your Apple ID email"
    echo "  NOTARIZE_TEAM_ID - Your Developer Team ID"
    echo "  NOTARIZE_APP_PASSWORD - App-specific password"
    echo ""
    echo "To create an app-specific password:"
    echo "  https://appleid.apple.com/account/manage"
    exit 1
fi

echo "📤 Uploading to Apple for notarization..."
xcrun notarytool submit "$DMG_PATH" \
    --apple-id "$APPLE_ID" \
    --team-id "$TEAM_ID" \
    --password "$APP_PASSWORD" \
    --wait

echo "📥 Stapling notarization ticket..."
xcrun stapler staple "$DMG_PATH"

echo "✅ Notarization complete!"
echo "DMG is now ready for distribution: $DMG_PATH"
