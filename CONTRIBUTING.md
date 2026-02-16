# Contributing to VHS Capture

Thank you for your interest in contributing to VHS Capture! This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what's best for the community
- Show empathy towards other community members

## How to Contribute

### Reporting Bugs

Before creating a bug report:
1. Check the [existing issues](https://github.com/yourusername/vhscapture/issues)
2. Verify you're using the latest version
3. Try to reproduce the bug

When creating a bug report, include:
- **macOS version** (e.g., macOS 13.6)
- **App version** (check About window)
- **USB capture device** model and manufacturer
- **Steps to reproduce** the issue
- **Expected behavior**
- **Actual behavior**
- **Screenshots or videos** if applicable
- **Crash logs** if app crashed

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:
- **Clear description** of the feature
- **Use case** - why is this useful?
- **Proposed implementation** (optional)
- **Mockups or examples** (optional)

### Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/vhscapture.git
   cd vhscapture
   ```

2. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the [code style guidelines](#code-style)
   - Write clear commit messages
   - Test your changes thoroughly

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add: Brief description of changes"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**
   - Provide a clear description of changes
   - Reference any related issues
   - Include screenshots/videos for UI changes
   - Ensure all checks pass

## Development Setup

### Prerequisites
- macOS 13.0 or later
- Xcode 15.0 or later
- Git
- (Optional) USB video capture device for testing

### Setting Up Development Environment

1. **Clone and setup**
   ```bash
   git clone https://github.com/yourusername/vhscapture.git
   cd vhscapture
   ```

2. **Create Xcode project**

   Follow the detailed instructions in [SETUP.md](SETUP.md)

3. **Build and run**
   ```bash
   # Option 1: Using Xcode (recommended)
   open VHSCapture.xcodeproj
   # Press ⌘R to build and run

   # Option 2: Using build script (after Xcode project setup)
   ./scripts/build.sh
   ```

### Project Structure

See [CLAUDE.md](CLAUDE.md) for detailed architecture documentation.

```
VHSCapture/
├── Models/           # Data structures
├── ViewModels/       # State management
├── Views/            # SwiftUI views
├── Services/         # Business logic
└── Utilities/        # Helper functions
```

## Code Style

### Swift Style Guide

Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).

#### Key Points:
- Use 4 spaces for indentation (not tabs)
- Maximum line length: 120 characters
- Use meaningful variable/function names
- Add comments for complex logic
- Use SwiftLint for consistency (optional)

#### Naming Conventions:
- **Types**: `PascalCase` (e.g., `CaptureDevice`, `VideoRecording`)
- **Functions/Variables**: `camelCase` (e.g., `startRecording()`, `currentTime`)
- **Constants**: `camelCase` (e.g., `defaultQuality`)
- **Enums**: `PascalCase` for type, `camelCase` for cases

#### SwiftUI Patterns:
```swift
// Good
struct CaptureView: View {
    @StateObject private var viewModel = CaptureViewModel()

    var body: some View {
        VStack {
            // Content
        }
    }
}

// Avoid deeply nested views
// Extract subviews into separate components
```

#### State Management:
- Use `@StateObject` for ViewModel ownership
- Use `@ObservedObject` when passing ViewModels
- Use `@State` for local view state
- Use `@Published` in ViewModels for observable properties

### Commit Messages

Format: `Type: Brief description`

**Types:**
- `Add:` - New feature
- `Fix:` - Bug fix
- `Update:` - Modify existing feature
- `Refactor:` - Code restructuring
- `Docs:` - Documentation changes
- `Test:` - Add or modify tests
- `Chore:` - Maintenance tasks

**Examples:**
```
Add: Video thumbnail generation in library
Fix: Crash when disconnecting device during capture
Update: Improve timeline scrubbing performance
Refactor: Extract timeline logic into separate service
Docs: Update SETUP.md with M1 Mac instructions
```

## Testing

### Manual Testing Checklist

Before submitting a PR:
- [ ] App builds without errors
- [ ] No compiler warnings (resolve or document why)
- [ ] Test with physical USB capture device
- [ ] Test capture → trim → export workflow
- [ ] Test both H.264 and H.265 codecs
- [ ] Test error cases (no device, permissions denied)
- [ ] Verify memory usage (no leaks)
- [ ] Test on macOS 13.0 (if possible)

### Test Coverage Areas
1. **Device Discovery** - Connect/disconnect devices
2. **Capture** - Start/stop, long recordings
3. **Trim** - Timeline interactions, edge cases
4. **Export** - All codecs, quality settings
5. **Navigation** - All screen transitions
6. **Errors** - Permission denial, disk full, etc.

## Documentation

When adding features:
- Update README.md if user-facing
- Update SETUP.md if affecting build process
- Update CLAUDE.md if architectural changes
- Add inline comments for complex logic
- Update CHANGELOG.md with changes

## Release Process

Maintainers will:
1. Update version in `Info.plist`
2. Update `CHANGELOG.md`
3. Create git tag (`v1.x.x`)
4. Build DMG with `./scripts/create-dmg.sh`
5. Create GitHub release with DMG attached
6. Update documentation as needed

## Questions?

- Check [CLAUDE.md](CLAUDE.md) for architecture details
- Check [SETUP.md](SETUP.md) for build instructions
- Open a [GitHub Discussion](https://github.com/yourusername/vhscapture/discussions)
- Ask in the issue tracker

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to VHS Capture! 🎬
