#!/bin/bash
# Create a GitHub release with DMG

set -e

VERSION="$1"

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 v1.0.0"
    exit 1
fi

echo "📦 Creating GitHub release $VERSION..."

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) not found"
    echo "Install it with: brew install gh"
    echo "Then authenticate with: gh auth login"
    exit 1
fi

# Check if DMG exists
DMG_FILE="dmg/VHSCapture-${VERSION#v}.dmg"

if [ ! -f "$DMG_FILE" ]; then
    echo "⚠️  Warning: DMG not found at: $DMG_FILE"
    echo ""
    read -p "Do you want to create the DMG now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Building app and creating DMG..."
        ./scripts/build.sh
        ./scripts/create-dmg.sh
        DMG_FILE="dmg/VHSCapture-1.0.0.dmg"  # Default version
    else
        echo "Skipping DMG creation..."
        DMG_FILE=""
    fi
fi

# Create git tag
echo "🏷️  Creating git tag..."
if git tag | grep -q "^${VERSION}$"; then
    echo "Tag $VERSION already exists"
else
    git tag -a "$VERSION" -m "Release $VERSION"
    git push origin "$VERSION"
fi

# Generate release notes from CHANGELOG
RELEASE_NOTES=$(cat CHANGELOG.md | awk '/^## \[1.0.0\]/, /^## \[/')

# Create GitHub release
echo "🚀 Creating GitHub release..."
if [ -n "$DMG_FILE" ] && [ -f "$DMG_FILE" ]; then
    gh release create "$VERSION" \
        "$DMG_FILE" \
        --title "VHS Capture $VERSION" \
        --notes-file <(echo "$RELEASE_NOTES")
else
    gh release create "$VERSION" \
        --title "VHS Capture $VERSION" \
        --notes-file <(echo "$RELEASE_NOTES") \
        --draft

    echo ""
    echo "⚠️  Release created as DRAFT (no DMG attached)"
    echo "To upload DMG later:"
    echo "  gh release upload $VERSION dmg/VHSCapture-${VERSION#v}.dmg"
    echo "  gh release edit $VERSION --draft=false"
fi

echo ""
echo "✅ Release $VERSION created!"
echo "🌐 View at: https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/releases"
