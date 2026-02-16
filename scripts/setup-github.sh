#!/bin/bash
# Setup GitHub repository and push code

set -e

echo "🚀 Setting up GitHub repository for VHS Capture..."

# Get GitHub username
read -p "Enter your GitHub username: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ Error: GitHub username required"
    exit 1
fi

REPO_NAME="vhscapture"
REPO_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

echo ""
echo "Repository will be pushed to: $REPO_URL"
echo ""
echo "⚠️  Make sure you've created the repository on GitHub first:"
echo "   https://github.com/new"
echo "   Repository name: vhscapture"
echo "   Description: A modern macOS application for USB video capture and VHS digitization"
echo "   Public/Private: Your choice"
echo "   Do NOT initialize with README, .gitignore, or license (we have those)"
echo ""
read -p "Press Enter when you've created the repository on GitHub..."

# Add remote
echo "🔗 Adding GitHub remote..."
if git remote | grep -q "^origin$"; then
    echo "Remote 'origin' already exists, updating URL..."
    git remote set-url origin "$REPO_URL"
else
    git remote add origin "$REPO_URL"
fi

# Push to GitHub
echo "📤 Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅ Successfully pushed to GitHub!"
echo ""
echo "🌐 View your repository at: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
echo ""
echo "Next steps:"
echo "  1. Update README.md badges with your GitHub username"
echo "  2. Create a release: ./scripts/create-release.sh v1.0.0"
echo "  3. Enable GitHub Actions in repository settings"
echo "  4. Build the app and create a DMG for the release"
