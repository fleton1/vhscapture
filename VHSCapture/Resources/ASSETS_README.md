# Assets Directory

This directory should contain an Xcode Asset Catalog (`Assets.xcassets`).

## Creating the Asset Catalog in Xcode

1. Right-click on the `Resources` folder in Xcode
2. Select "New File..."
3. Choose "Asset Catalog"
4. Name it "Assets"
5. Click "Create"

## Required Assets

### App Icon
- **Name**: AppIcon
- **Type**: macOS App Icon
- **Sizes needed**:
  - 16x16
  - 32x32
  - 64x64
  - 128x128
  - 256x256
  - 512x512
  - 1024x1024

Create a simple icon with:
- Film reel or VHS tape imagery
- Blue/purple gradient background
- Modern, minimal design

### Color Assets (Optional)

Add brand colors for consistent theming:
- **AccentColor**: Primary brand color
- **RecordingRed**: Red for recording indicator
- **TimelineBlue**: Blue for timeline elements

### Symbol Images (Optional)

Custom SF Symbols or images:
- Custom recording button
- Custom trim markers
- Export format icons

## Design Guidelines

### App Icon Design
- Keep it simple and recognizable
- Use vector graphics (SVG) when possible
- Ensure it looks good at all sizes
- Consider light and dark mode variants

### Color Palette
- Primary: Blue (#007AFF) - macOS accent color
- Recording: Red (#FF3B30)
- Success: Green (#34C759)
- Warning: Orange (#FF9500)
- Error: Red (#FF3B30)

## Tools for Creating Assets

- **SF Symbols App** - For system icons
- **Sketch** - Vector design tool for macOS
- **Figma** - Online design tool
- **Adobe Illustrator** - Professional vector design
- **Icon Generator** - Online tool for generating icon sizes

## Asset Catalog Structure

```
Assets.xcassets/
├── AppIcon.appiconset/
│   ├── Contents.json
│   ├── icon_16x16.png
│   ├── icon_32x32.png
│   ├── ...
│   └── icon_1024x1024.png
├── AccentColor.colorset/
│   └── Contents.json
└── RecordingRed.colorset/
    └── Contents.json
```

## Placeholder Icon

For development, you can use SF Symbols as placeholder:
- Use `film.fill` as the app's visual identifier
- This is already used throughout the UI

## Adding Assets to Xcode

1. Open `Assets.xcassets` in Xcode
2. Click the `+` button at the bottom
3. Choose the asset type (Image Set, Color Set, etc.)
4. Drag and drop your assets into the wells
5. Set the appropriate scale (1x, 2x, 3x for images)

## Usage in Code

### App Icon
Set in project settings:
1. Select project in navigator
2. Select target
3. Go to "General" tab
4. Under "App Icon", select your asset catalog

### Colors in SwiftUI
```swift
Color("AccentColor")
Color("RecordingRed")
```

### Images in SwiftUI
```swift
Image("myCustomImage")
```

## Asset Requirements for Distribution

- App icon is **required** for App Store submission
- All icon sizes must be provided
- Use PNG format with transparency
- No transparency in App Store icon (1024x1024)
- Adhere to Apple's Human Interface Guidelines

## Resources

- [Apple Human Interface Guidelines - App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [SF Symbols App](https://developer.apple.com/sf-symbols/)
- [Xcode Asset Catalog Documentation](https://developer.apple.com/documentation/xcode/asset-management)

---

**Note**: This directory is currently empty. Create the asset catalog in Xcode when setting up the project.
