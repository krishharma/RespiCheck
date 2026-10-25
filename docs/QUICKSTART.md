# RespiCheck - Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### 1. Open the Project
```bash
cd /Users/krishsharma/Desktop/MobileAppDev/PnScreenerSTEM/PnScreener
open PnScreener.xcodeproj
```

### 2. Select Target Device
- Click on the device selector in Xcode (top-left, next to the Run button)
- Choose: **iPhone 15 Pro** or any iOS 16+ simulator
- Or connect a physical iPhone running iOS 16+

### 3. Build and Run
- Press `Cmd + R` or click the Play button
- Wait for build to complete (first build takes ~30 seconds)
- App will launch automatically

### 4. Grant Permissions
When the app requests permissions:
- **Location**: Tap "Allow While Using App" to enable provider search
- **Microphone**: Tap "Allow" to enable cough recording

## 📱 Testing the Full Flow

### Test Path (5 minutes)
1. **Welcome Screen** → Select "English" → Tap "Get Started"
2. **Profile Setup** → 
   - Tap "Allow Location Access" (or enter ZIP: 94102)
   - Select any insurance type
   - Tap "Continue"
3. **Symptom Survey** → 
   - Answer "Yes" or "No" to 8 questions
   - Automatically advances to next screen
4. **Audio Recording** → 
   - Tap the blue microphone button
   - Make a cough sound (or any sound)
   - Tap again to stop
   - Tap "Submit"
5. **Analysis** → Watch the animated progress (3 seconds)
6. **Results** → View your risk assessment
7. **Find Care** → Browse nearby healthcare providers

## 🎨 Key Features to Test

### Accessibility
- Go to **Settings** → **Accessibility** → **Display & Text Size**
- Enable **Larger Text** and slide to maximum
- Return to app - all text should scale properly
- Enable **VoiceOver** to test screen reader

### Multilingual
- From Welcome screen, tap language selector
- Choose "Español" or "中文"
- Interface should update (partially - full i18n in localization files)

### Provider Map
- On the "Find Care" screen
- Tap the map icon (top-right)
- See providers plotted on map
- Tap a pin to see provider details
- Tap "Call" to open phone dialer
- Tap "Directions" to open Apple Maps

### Settings & Privacy
- Tap settings icon (gear) in navigation bar
- Try "Update Profile" to change information
- Tap "Delete All Session Data" to reset the app
- View "Privacy Policy" and "About RespiCheck"

## 🔧 Troubleshooting

### Build Errors
**Issue**: "No such module 'SwiftUI'"
- **Fix**: Ensure iOS Deployment Target is set to 16.0+
- Go to Project Settings → General → Minimum Deployments

**Issue**: Audio recording doesn't work
- **Fix**: Add microphone permission to Info.plist
- Should already be configured in the provided Info.plist

**Issue**: Location not working in simulator
- **Fix**: Simulator → Features → Location → Custom Location
- Enter: Lat 37.7749, Long -122.4194 (San Francisco)

### Runtime Issues
**Issue**: App crashes on audio recording
- **Fix**: Run on physical device (simulator audio is limited)
- Or check microphone permission in Settings app

**Issue**: Map doesn't show providers
- **Fix**: Using mock data - should show 5 providers around SF
- Check that `ProviderModel.mockProviders` is not empty

**Issue**: Navigation stuck
- **Fix**: Tap "Back" button in navigation bar
- Or rebuild app to reset state

## 📂 File Structure Quick Reference

```
Key Files to Explore:
├── PnScreenerApp.swift          ← App entry point
├── Views/
│   ├── MainCoordinatorView.swift  ← Navigation logic
│   ├── SplashView.swift           ← First screen you see
│   └── UserInfoView.swift         ← Profile setup
├── Models/
│   └── UserModel.swift            ← Data structures
└── ViewModels/
    └── UserViewModel.swift        ← Business logic
```

## 🎯 Next Steps

### For Development
1. **Add Real Backend**: Replace mock data in `AudioAnalyzerViewModel`
2. **Customize Branding**: Update colors in each view
3. **Add More Languages**: Create new `.lproj` folders
4. **Implement Analytics**: Add tracking to ViewModels

### For Production
1. **Security**: Move UserDefaults to Keychain
2. **Privacy**: Implement proper HIPAA compliance
3. **Testing**: Add unit tests for ViewModels
4. **CI/CD**: Set up Xcode Cloud or GitHub Actions

## 💡 Tips

- **Preview Mode**: Open any View file, click "Resume" in Canvas to see live preview
- **Hot Reload**: Modify view code while app is running for instant updates
- **Debug Area**: `Cmd + Shift + Y` to see console logs
- **Clean Build**: `Cmd + Shift + K` if you encounter strange build issues

## 🆘 Need Help?

- Check `README.md` for detailed documentation
- Review inline code comments in Swift files
- Each View has a `#Preview` at the bottom - great for learning
- Apple's SwiftUI Documentation: https://developer.apple.com/documentation/swiftui

## ✅ Checklist: Is Everything Working?

- [ ] App builds without errors
- [ ] Welcome screen displays with gradient background
- [ ] Can select language from dropdown
- [ ] Profile screen accepts location and insurance
- [ ] Symptom survey shows questions with icons
- [ ] Can record audio (mic button works)
- [ ] Analysis screen shows animated progress
- [ ] Results screen displays risk level with color
- [ ] Provider list shows 5 mock providers
- [ ] Map view displays provider locations
- [ ] Settings screen opens from gear icon
- [ ] Resources screen shows educational cards
- [ ] All text is readable and properly sized
- [ ] Navigation flows smoothly forward and back

If all boxes are checked, you're ready to start customizing! 🎉

---

**Built with**: SwiftUI, Combine, AVFoundation, CoreLocation, MapKit
**Target**: iOS 16.0+
**Language**: Swift 5.7+

