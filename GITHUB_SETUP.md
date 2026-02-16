# GitHub Setup and Release Guide

Complete guide for pushing VHS Capture to GitHub and creating releases with DMG files.

## Prerequisites

1. **GitHub Account** - Create at https://github.com/join if you don't have one
2. **GitHub CLI** (optional but recommended) - Install with:
   ```bash
   # macOS
   brew install gh

   # Or download from https://cli.github.com
   ```
3. **Git configured** - Already done ✓

## Step 1: Create GitHub Repository

### Option A: Using GitHub Website

1. Go to https://github.com/new
2. Fill in the details:
   - **Repository name**: `vhscapture`
   - **Description**: `A modern macOS application for USB video capture and VHS digitization`
   - **Visibility**: Public (or Private if preferred)
   - **DO NOT** check any initialization options (README, .gitignore, license)
3. Click "Create repository"

### Option B: Using GitHub CLI

```bash
gh auth login  # Authenticate if not already done
gh repo create vhscapture --public --description "A modern macOS application for USB video capture and VHS digitization"
```

## Step 2: Push to GitHub

### Quick Method - Using Script

```bash
./scripts/setup-github.sh
```

This will:
- Prompt for your GitHub username
- Add the remote repository
- Push your code to GitHub

### Manual Method

```bash
# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/vhscapture.git

# Push to GitHub
git push -u origin main
```

## Step 3: Update Repository Settings

After pushing, update your README.md badges:

```bash
# Replace 'yourusername' with your actual GitHub username in README.md
sed -i '' 's/yourusername/YOUR_ACTUAL_USERNAME/g' README.md

# Commit the change
git add README.md
git commit -m "Update: Replace placeholder username in README badges"
git push
```

## Step 4: Build the App and Create DMG

**Note**: You need to create an Xcode project first. See [SETUP.md](SETUP.md).

### Build the Application

```bash
# This requires Xcode project setup (see SETUP.md)
./scripts/build.sh
```

### Create DMG Installer

```bash
./scripts/create-dmg.sh
```

This creates: `dmg/VHSCapture-1.0.0.dmg`

### (Optional) Notarize for Distribution

For distribution outside the App Store:

```bash
# Set environment variables
export NOTARIZE_APPLE_ID="your-apple-id@example.com"
export NOTARIZE_TEAM_ID="YOUR_TEAM_ID"
export NOTARIZE_APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"  # App-specific password

# Notarize
./scripts/notarize.sh dmg/VHSCapture-1.0.0.dmg
```

## Step 5: Create GitHub Release

### Quick Method - Using Script

```bash
./scripts/create-release.sh v1.0.0
```

This will:
- Create git tag `v1.0.0`
- Push tag to GitHub
- Create release with DMG attached
- Use CHANGELOG.md for release notes

### Manual Method - Using GitHub CLI

```bash
# Create and push tag
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Create release with DMG
gh release create v1.0.0 \
    dmg/VHSCapture-1.0.0.dmg \
    --title "VHS Capture v1.0.0" \
    --notes "See CHANGELOG.md for details"
```

### Manual Method - Using GitHub Website

1. Go to your repository on GitHub
2. Click "Releases" in the right sidebar
3. Click "Create a new release"
4. Fill in:
   - **Tag**: `v1.0.0`
   - **Title**: `VHS Capture v1.0.0`
   - **Description**: Copy from CHANGELOG.md
   - **Attach files**: Drag `dmg/VHSCapture-1.0.0.dmg`
5. Click "Publish release"

## Step 6: Enable GitHub Actions

GitHub Actions will automatically build and release when you push tags.

1. Go to your repository → Settings → Actions
2. Enable "Allow all actions and reusable workflows"
3. Push a tag to trigger the workflow:
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```

**Note**: The workflow requires an Xcode project in the repository. See the note in `.github/workflows/build.yml`.

## Complete Workflow Example

```bash
# 1. Create repository on GitHub
# (Via website or gh CLI)

# 2. Push code
./scripts/setup-github.sh

# 3. Update README with your username
sed -i '' 's/yourusername/YOUR_USERNAME/g' README.md
git add README.md
git commit -m "Update: Replace username in README"
git push

# 4. Build app (requires Xcode project setup first)
# See SETUP.md for creating Xcode project

# 5. Create DMG
./scripts/build.sh
./scripts/create-dmg.sh

# 6. Create release
./scripts/create-release.sh v1.0.0
```

## Troubleshooting

### Can't push to GitHub

**Error**: `remote: Permission denied`

**Solution**:
- Make sure you have write access to the repository
- Check your Git credentials: `git config user.name` and `git config user.email`
- Use SSH instead: `git remote set-url origin git@github.com:USERNAME/vhscapture.git`

### DMG creation fails

**Error**: `App not found`

**Solution**: Build the app first with `./scripts/build.sh`

### GitHub CLI not authenticated

**Error**: `authentication required`

**Solution**:
```bash
gh auth login
# Follow the prompts
```

### Xcode project not found

**Error**: `Xcode project not found!`

**Solution**: Create an Xcode project first. See [SETUP.md](SETUP.md) for detailed instructions.

## Alternative: Without Building App

If you want to push to GitHub without building the app first:

```bash
# Push code only
./scripts/setup-github.sh

# Create a draft release without DMG
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

gh release create v1.0.0 \
    --title "VHS Capture v1.0.0" \
    --notes "See CHANGELOG.md for details" \
    --draft
```

Then build the app later and upload the DMG:

```bash
# After building
gh release upload v1.0.0 dmg/VHSCapture-1.0.0.dmg
gh release edit v1.0.0 --draft=false
```

## Next Steps After Publishing

1. **Share the repository**
   - Add topics/tags to your repository (e.g., `macos`, `swift`, `video-capture`)
   - Star your own repository
   - Share on social media

2. **Enable Discussions** (optional)
   - Go to Settings → Features
   - Enable Discussions

3. **Add collaborators** (if working with others)
   - Go to Settings → Collaborators
   - Add GitHub usernames

4. **Configure branch protection** (for serious projects)
   - Go to Settings → Branches
   - Add rule for `main` branch

## Resources

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub Releases Guide](https://docs.github.com/en/repositories/releasing-projects-on-github)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

**Quick Reference**

```bash
# Push to GitHub
./scripts/setup-github.sh

# Build and create DMG
./scripts/build.sh && ./scripts/create-dmg.sh

# Create release
./scripts/create-release.sh v1.0.0
```
