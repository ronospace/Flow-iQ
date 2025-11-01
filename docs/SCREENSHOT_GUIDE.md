# App Store Screenshot Creation Guide

## Overview
You need to capture professional screenshots WITHOUT debug banners for App Store submission.

## Required Screenshot Sizes

### iPhone 6.7" Display (iPhone 15 Pro Max, 16 Pro Max)
- **Resolution:** 1290 x 2796 pixels
- **Device:** iPhone 15 Pro Max or 16 Pro Max simulator
- **Minimum:** 6 screenshots

### iPhone 6.5" Display (iPhone 11 Pro Max, XS Max)
- **Resolution:** 1242 x 2688 pixels
- **Device:** iPhone 11 Pro Max or XS Max simulator
- **Minimum:** 6 screenshots

### iPad Pro (2nd gen) 12.9"
- **Resolution:** 2048 x 2732 pixels (portrait)
- **Device:** iPad Pro 12.9" simulator
- **Minimum:** 6 screenshots

---

## Method 1: Manual Screenshots (Recommended)

### Step 1: Launch Simulator
```bash
# For iPhone (6.7" display)
open -a Simulator
# Then boot iPhone 15 Pro Max or 16 Pro Max

# For iPad
open -a Simulator
# Then boot iPad Pro 12.9"
```

### Step 2: Build and Run in Debug Mode
```bash
flutter run -d "iPhone 15 Pro Max"
# OR
flutter run -d "iPad Pro (12.9-inch)"
```

### Step 3: Navigate and Capture
1. Let the app fully load and sign in with demo account:
   - Email: demo@flowiq.health
   - Password: FlowIQ2024Demo!

2. Navigate to each key screen and take screenshots (Cmd+S):
   - **Screenshot 1:** Home Dashboard (showing cycle overview)
   - **Screenshot 2:** Tracking Screen (period logging interface)
   - **Screenshot 3:** Insights Screen (AI-powered analysis with citations)
   - **Screenshot 4:** Health Screen (comprehensive health data)
   - **Screenshot 5:** AI Features (showing medical citations)
   - **Screenshot 6:** Settings Screen (theme switcher, options)

3. Screenshots are saved to Desktop by default

### Step 4: Verify Screenshots
- Check that NO debug banner appears (top-right corner)
- Ensure all text is readable
- Verify Flow iQ branding is visible
- Check for proper colors and layout

---

## Method 2: Using Xcode Device Frames

### Step 1: Take Basic Screenshots
Follow Method 1 to capture raw screenshots

### Step 2: Add Device Frames
```bash
# Install screenshot tool (if not already installed)
brew install fastlane

# Use fastlane frameit to add device frames
fastlane frameit
```

---

## Method 3: Using Screenshot Automation (Advanced)

### Create integration test for screenshots:

```bash
# Create test file
touch integration_test/screenshot_test.dart
```

Add this content:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flow_ai/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Generate App Store screenshots', (tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(seconds: 5));
    
    // Screenshot 1: Splash/Auth Screen
    await binding.takeScreenshot('01-auth');
    
    // Login
    await tester.enterText(find.byType(TextField).first, 'demo@flowiq.health');
    await tester.enterText(find.byType(TextField).last, 'FlowIQ2024Demo!');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle(Duration(seconds: 3));
    
    // Screenshot 2: Home Dashboard
    await binding.takeScreenshot('02-home');
    
    // Navigate to Tracking
    await tester.tap(find.text('Track'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('03-tracking');
    
    // Navigate to Insights
    await tester.tap(find.text('Insights'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('04-insights');
    
    // Navigate to Health
    await tester.tap(find.text('Health'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('05-health');
    
    // Navigate to Settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('06-settings');
  });
}
```

### Run the test:

```bash
# For iPhone
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/screenshot_test.dart \
  -d "iPhone 15 Pro Max"

# For iPad
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/screenshot_test.dart \
  -d "iPad Pro (12.9-inch)"
```

---

## Screenshot Content Guidelines

### ✅ DO:
- Show real, meaningful data
- Display Flow iQ branding clearly
- Use consistent demo account data
- Show medical citations on AI screens
- Display clean, professional layouts
- Include theme variety (light/dark)
- Show key features prominently

### ❌ DON'T:
- Include debug banners
- Show development tools
- Use placeholder or Lorem ipsum text
- Display error states
- Include personal/sensitive data
- Show unfinished features
- Use low-quality images

---

## Recommended Screenshot Order

### Set 1: Core Features
1. **Home Dashboard** - Cycle overview with beautiful visualization
2. **Tracking Screen** - Easy period and symptom logging
3. **AI Insights** - Intelligent predictions with medical citations
4. **Health Analysis** - Comprehensive health data view
5. **Settings** - Theme switcher and customization options
6. **Calendar View** - Monthly cycle calendar

### Set 2: Advanced Features (Optional)
1. Integration with Flow-iQ professional platform
2. Detailed symptom tracking interface
3. Medication and supplement logging
4. Sleep and exercise monitoring
5. Photo journaling feature
6. Export and sharing capabilities

---

## Post-Processing (Optional)

### Tools for Enhancement:
- **Photoshop** - Add captions, highlights
- **Sketch** - Design mockups with device frames
- **Figma** - Create marketing visuals
- **Preview** (macOS) - Basic cropping and adjustments

### Captions to Add (Optional):
- "Track your cycle with clinical precision"
- "AI-powered insights backed by medical research"
- "Comprehensive health analytics"
- "Beautiful, intuitive interface"
- "Seamlessly sync with healthcare providers"
- "Your data, your control"

---

## Upload to App Store Connect

### Step 1: Organize Screenshots
Create folders for each device size:
```
screenshots/
├── iPhone_6.7/
│   ├── 01-home.png
│   ├── 02-tracking.png
│   ├── 03-insights.png
│   ├── 04-health.png
│   ├── 05-ai.png
│   └── 06-settings.png
├── iPhone_6.5/
│   └── (same as above)
└── iPad_12.9/
    └── (same as above)
```

### Step 2: Upload via App Store Connect
1. Log in to [App Store Connect](https://appstoreconnect.apple.com)
2. Select Flow iQ app
3. Go to version 2.0.3
4. Scroll to "App Preview and Screenshots"
5. Select each device type
6. Drag and drop screenshots in order
7. Add optional captions below each screenshot
8. Save changes

---

## Quality Checklist

Before uploading, verify:

- [ ] Correct resolution for each device type
- [ ] NO debug banners visible
- [ ] Consistent demo account data across all screenshots
- [ ] Flow iQ branding visible
- [ ] Clean, professional appearance
- [ ] Medical disclaimers visible where appropriate
- [ ] All text readable
- [ ] Colors render correctly
- [ ] Proper aspect ratio maintained
- [ ] File names organized clearly

---

## Quick Reference Commands

```bash
# List available simulators
xcrun simctl list devices available

# Boot specific simulator
xcrun simctl boot "iPhone 15 Pro Max"

# Take screenshot manually
Cmd + S (in Simulator)

# Screenshot location
~/Desktop/Screen\ Shot\ *.png

# Run app on simulator
flutter run -d "iPhone 15 Pro Max"

# Build release for testing
flutter build ios --release

# Clean and rebuild
flutter clean && flutter pub get && flutter build ios
```

---

## Troubleshooting

### Issue: Debug banner appears
**Solution:** Don't use `flutter run --release` on simulator (not supported). Take screenshots in debug mode - debug banner should only appear in dev builds.

### Issue: Screenshots are wrong size
**Solution:** Use correct simulator model. Check with:
```bash
xcrun simctl list devices | grep "iPhone 15 Pro Max"
```

### Issue: App crashes in simulator
**Solution:** Run in debug mode first to identify issues. Check console for errors.

### Issue: Colors look different
**Solution:** Ensure simulator display settings match device. Calibrate display if needed.

---

## Next Steps

1. ✅ Take all required screenshots
2. ✅ Verify quality and content
3. ✅ Organize in proper folders
4. ✅ Upload to App Store Connect
5. ✅ Add captions (optional)
6. ✅ Save and submit for review

---

**Last Updated:** November 1, 2025
**App Version:** 2.0.3
