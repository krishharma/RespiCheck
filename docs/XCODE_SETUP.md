# Xcode Project Configuration Guide

## Project Settings Checklist

### 1. Add All Files to Xcode Project

**Important**: The Swift files have been created, but you need to add them to your Xcode project.

#### Steps to Add Files:
1. Open Xcode project
2. Right-click on the "PnScreener" folder in Project Navigator
3. Select "Add Files to PnScreener..."
4. Navigate to each folder and select all Swift files:

```
Add these folders/files:
□ Models/
  □ UserModel.swift
  □ SurveyModel.swift
  □ ProviderModel.swift
  □ AudioModel.swift

□ ViewModels/
  □ UserViewModel.swift
  □ SurveyViewModel.swift
  □ AudioAnalyzerViewModel.swift
  □ ProviderMatchViewModel.swift

□ Components/
  □ CustomButton.swift
  □ CardView.swift
  □ ProgressIndicator.swift
  □ ProviderListItem.swift

□ Views/
  □ SplashView.swift
  □ UserInfoView.swift
  □ SymptomView.swift
  □ AudioCaptureView.swift
  □ AnalysisView.swift
  □ ResultsView.swift
  □ ProviderNavigationView.swift
  □ ResourcesView.swift
  □ SettingsView.swift
  □ MainCoordinatorView.swift

□ Localization/
  □ Localizable.strings
  □ es.lproj/Localizable.strings
  □ zh.lproj/Localizable.strings

□ Info.plist (if not auto-detected)
```

**Make sure to check**: 
- ✅ "Copy items if needed"
- ✅ "Create groups"
- ✅ Target: PnScreener (main app target checked)

### 2. Configure Info.plist

The `Info.plist` file has been created with required permissions. 

#### Verify Permissions in Xcode:
1. Select project in Navigator
2. Select "PnScreener" target
3. Go to "Info" tab
4. Verify these keys exist:

```xml
✓ Privacy - Location When In Use Usage Description
✓ Privacy - Microphone Usage Description
✓ Localization native development region
✓ Localizations (en, es, zh-Hans)
```

#### Alternative: Manual Entry
If Info.plist doesn't auto-import:
1. Open existing Info.plist in Xcode
2. Right-click → "Add Row"
3. Add each key:
   - **NSLocationWhenInUseUsageDescription**: "RespiCheck uses your location to find nearby healthcare providers..."
   - **NSMicrophoneUsageDescription**: "RespiCheck needs microphone access to record your cough..."

### 3. Set Deployment Target

1. Select project in Navigator
2. Select "PnScreener" target
3. Go to "General" tab
4. Set **Minimum Deployments**: **iOS 16.0**

### 4. Configure Localizations

1. Select project (not target) in Navigator
2. Go to "Info" tab
3. Under "Localizations", click "+"
4. Add:
   - ✅ Spanish (es)
   - ✅ Chinese, Simplified (zh-Hans)

5. For each localization:
   - Select `Localizable.strings`
   - Check the language boxes in File Inspector

### 5. App Signing

1. Select "PnScreener" target
2. Go to "Signing & Capabilities"
3. Check "Automatically manage signing"
4. Select your Team (if available)
5. Bundle Identifier: `com.yourcompany.PnScreener` (update as needed)

### 6. Enable Required Capabilities

The app needs these capabilities (most are automatic):

1. Go to "Signing & Capabilities" tab
2. Verify or add:
   - ✅ Maps (auto-enabled when importing MapKit)
   - ✅ Location (auto-enabled when requesting permission)
   - ✅ Audio (auto-enabled with AVFoundation)

*Note: These should be automatically enabled when you use the frameworks in code.*

### 7. Build Settings

Verify these settings in "Build Settings":

```
Swift Language Version: Swift 5
iOS Deployment Target: 16.0
Code Signing Identity: Apple Development
```

### 8. Add Folders to Project (Optional but Recommended)

For better organization, create groups in Xcode:

1. Right-click "PnScreener" folder
2. Select "New Group"
3. Create groups matching folder structure:
   - Models
   - ViewModels
   - Views
   - Components
   - Localization
4. Drag corresponding files into each group

## Build Phases Configuration

### 1. Compile Sources
Should automatically include all `.swift` files when added to target.

Verify:
1. Select target → "Build Phases"
2. Expand "Compile Sources"
3. Should see ~25 Swift files listed

If files are missing:
- Click "+" → Add missing Swift files

### 2. Copy Bundle Resources
Should include:
- `Assets.xcassets`
- `Info.plist`
- All `.strings` files
- Any localization folders

## Common Issues & Fixes

### Issue 1: "No such module" errors

**Fix**:
1. Clean build folder: `Cmd + Shift + K`
2. Quit Xcode
3. Delete DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
4. Reopen project and rebuild

### Issue 2: Files show in red

**Fix**:
1. Select red file in Navigator
2. Open File Inspector (right panel)
3. Under "Location", click folder icon
4. Locate the actual file
5. Or remove and re-add file to project

### Issue 3: Localizable.strings not working

**Fix**:
1. Select `Localizable.strings` in Navigator
2. Open File Inspector
3. Click "Localize..."
4. Select base language
5. Check all target languages in the inspector

### Issue 4: Info.plist not recognized

**Fix**:
1. Select project → target → "Build Settings"
2. Search for "Info.plist"
3. Set "Info.plist File" to: `PnScreener/Info.plist`

### Issue 5: Simulator crashes on audio recording

**Expected behavior**: Audio recording works best on real devices.

**Workaround**:
- Use iPhone 14+ simulator (newer audio support)
- Or test on physical device for audio features

## File Organization Best Practices

```
PnScreener/
├── Models/           # Data structures (no UI dependencies)
├── ViewModels/       # Business logic (ObservableObject)
├── Views/            # SwiftUI views (display only)
├── Components/       # Reusable UI components
├── Localization/     # String translations
├── Resources/        # Images, assets
└── App/
    ├── PnScreenerApp.swift  # App entry
    └── Info.plist
```

## Testing Your Setup

### Quick Test Build
```bash
# From terminal in project directory:
xcodebuild -project PnScreener.xcodeproj \
           -scheme PnScreener \
           -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
           clean build
```

### Expected Output:
```
BUILD SUCCEEDED
```

If you see errors, they'll indicate which files couldn't be found or compiled.

## Pre-Flight Checklist

Before running the app:

- [ ] All Swift files added to Xcode project
- [ ] All files have target membership set to "PnScreener"
- [ ] Deployment target set to iOS 16.0+
- [ ] Info.plist configured with permissions
- [ ] Localizations added (en, es, zh-Hans)
- [ ] Build completes without errors
- [ ] No red files in Project Navigator
- [ ] Info.plist path set in Build Settings
- [ ] Code signing configured

## Next Steps

Once setup is complete:
1. Build the project (`Cmd + B`)
2. Fix any remaining import errors
3. Run on simulator (`Cmd + R`)
4. Test on physical device for full functionality

## Additional Resources

- [Apple: Adding Files to Projects](https://developer.apple.com/documentation/xcode/adding-files-to-your-project)
- [Apple: Localization Guide](https://developer.apple.com/localization/)
- [SwiftUI App Structure](https://developer.apple.com/documentation/swiftui/app-structure)

---

**Need help?** Check the console output in Xcode for specific error messages, then search for solutions or refer to Apple's documentation.

