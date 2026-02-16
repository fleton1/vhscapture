# VHS Capture - TODO List

## High Priority (Essential for v1.0)

- [ ] **Test with physical hardware**
  - [ ] Test with Elgato Video Capture device
  - [ ] Test with generic USB capture dongle
  - [ ] Test with Blackmagic capture card
  - [ ] Verify live preview works
  - [ ] Verify recording quality is acceptable
  - [ ] Test long recordings (1+ hour)

- [ ] **Generate video thumbnails**
  - [ ] Use AVAssetImageGenerator to create thumbnails
  - [ ] Display in library view instead of placeholder icons
  - [ ] Cache thumbnails for performance
  - [ ] Generate thumbnail at trim start point

- [ ] **Fix any Xcode project setup issues**
  - [ ] Ensure all files compile without errors
  - [ ] Resolve any import issues
  - [ ] Test on multiple macOS versions (13.0, 14.0, 15.0)

- [ ] **Error handling improvements**
  - [ ] Add retry logic for failed operations
  - [ ] Better error messages for common issues
  - [ ] Disk space warnings before recording
  - [ ] Handle device disconnection during capture

## Medium Priority (Nice to have for v1.0)

- [ ] **Audio monitoring**
  - [ ] Add audio level meters during capture
  - [ ] Mute/unmute audio preview
  - [ ] Audio waveform in timeline view

- [ ] **Deinterlacing**
  - [ ] Add deinterlacing filter option
  - [ ] Auto-detect interlaced content
  - [ ] Preview deinterlaced output

- [ ] **Keyboard shortcuts**
  - [ ] Implement Space for play/pause (currently planned)
  - [ ] Implement I/O for trim markers (currently planned)
  - [ ] Add ⌘R for record toggle
  - [ ] Add ⌘E for export
  - [ ] Add arrow keys for frame-by-frame navigation

- [ ] **UI refinements**
  - [ ] Add app icon
  - [ ] Improve color scheme (light/dark mode)
  - [ ] Add animation transitions
  - [ ] Loading indicators for long operations
  - [ ] Better empty states

- [ ] **Metadata editing**
  - [ ] Inline rename in library
  - [ ] Add notes/description field
  - [ ] Date picker for recording date
  - [ ] Tags or categories

## Low Priority (Future versions)

- [ ] **Advanced features**
  - [ ] Scene detection
  - [ ] Chapter markers
  - [ ] Batch export
  - [ ] Multi-select in library
  - [ ] Drag-and-drop import

- [ ] **Video filters**
  - [ ] Color correction
  - [ ] Brightness/contrast
  - [ ] Noise reduction
  - [ ] Sharpening

- [ ] **Export improvements**
  - [ ] Custom export presets
  - [ ] Background exports (continue working)
  - [ ] Queue multiple exports
  - [ ] Estimated time remaining

- [ ] **Library features**
  - [ ] Search and filter
  - [ ] Sort by date, duration, size
  - [ ] Collections/playlists
  - [ ] Star/favorite recordings
  - [ ] Export metadata to sidecar file

- [ ] **Advanced capture**
  - [ ] Scheduled recording (start/stop at time)
  - [ ] Motion detection
  - [ ] Automatic scene splitting
  - [ ] Time-lapse mode

- [ ] **Sharing**
  - [ ] Share to Messages, Mail
  - [ ] Upload to cloud services
  - [ ] Generate preview clips
  - [ ] Social media export presets

## Bugs to Fix

- [ ] Verify permission prompts appear correctly
- [ ] Test session cleanup when window closes
- [ ] Check for memory leaks with long sessions
- [ ] Validate file paths with special characters
- [ ] Test trim range edge cases (0 duration, etc.)

## Documentation

- [ ] Add inline documentation for public APIs
- [ ] Create architecture diagram
- [ ] Write troubleshooting guide
- [ ] Document USB device compatibility
- [ ] Add video tutorial or screenshots

## Testing

- [ ] Unit tests for models
- [ ] Unit tests for view models
- [ ] Integration tests for services
- [ ] UI tests for main workflows
- [ ] Performance testing with large files
- [ ] Memory leak testing

## Deployment

- [ ] Create app icon (1024x1024)
- [ ] Set up code signing
- [ ] Test notarization process
- [ ] Create DMG installer
- [ ] Write privacy policy
- [ ] Prepare App Store screenshots
- [ ] Submit for App Store review

## Code Quality

- [ ] Add SwiftLint configuration
- [ ] Document complex algorithms
- [ ] Refactor long methods
- [ ] Add error logging
- [ ] Improve code organization
- [ ] Add performance monitoring

## Accessibility

- [ ] Add VoiceOver labels
- [ ] Test with VoiceOver enabled
- [ ] Keyboard navigation for all features
- [ ] High contrast mode support
- [ ] Reduce motion support

---

## Completed ✅

- ✅ Phase 1: Basic Capture implementation
- ✅ Phase 2: Playback & File Management
- ✅ Phase 3: Video Trimming
- ✅ Phase 4: Export & Conversion
- ✅ Phase 5: Navigation & Workflow
- ✅ Phase 6: Polish & Error Handling (basic)
- ✅ Create all Swift source files
- ✅ Create Info.plist with permissions
- ✅ Create README.md
- ✅ Create SETUP.md
- ✅ Create Package.swift
- ✅ Create .gitignore
- ✅ Create PROJECT_SUMMARY.md
- ✅ Implement MVVM architecture
- ✅ Implement coordinator pattern
- ✅ Add preferences window
- ✅ Add error handling
- ✅ Add progress indicators
- ✅ Add file management utilities

---

**Notes:**
- Priority may change based on user feedback
- Mark items complete with ✅ as they're finished
- Add new items as they're discovered
- Review and update regularly
