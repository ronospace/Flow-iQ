# Flow iQ Branding Update - November 23, 2025

## Summary
Updated Android app branding to consistently display "Flow iQ" instead of "flow_ai" across all platforms.

## Changes Made

### 1. Android Manifest Update
**File:** `android/app/src/main/AndroidManifest.xml`
- **Changed:** `android:label="flow_ai"` 
- **To:** `android:label="Flow iQ"`
- **Impact:** Android devices will now display "Flow iQ" as the app name

### 2. iOS Configuration
**File:** `ios/Runner/Info.plist`
- **Status:** Already correctly set to "Flow iQ"
- **Keys:** `CFBundleDisplayName` and `CFBundleName` both set to "Flow iQ"
- **No changes needed**

### 3. Cache Cleanup
- Uninstalled cached app from iPhone 16 Pro simulator
- Ran `flutter clean` to remove build artifacts
- Fresh install now displays correct "Flow iQ" branding

## Backup Information
**Backup File:** `Flow-Ai_backup_20251123_205605.tar.gz`
**Location:** `/Users/ronos/Workspace/Projects/Active/`
**Created:** November 23, 2025, 20:56:05 UTC

## Git Commit
**Commit:** `6c1a865`
**Message:** "Update Android app label from 'flow_ai' to 'Flow iQ' for consistent branding"
**Branch:** main
**Status:** ✅ Pushed to remote

## Verification
- ✅ Android label updated
- ✅ iOS configuration verified (already correct)
- ✅ App icons present and configured
- ✅ Backup created successfully
- ✅ Changes committed and pushed to GitHub
- ✅ App displays as "Flow iQ" on device/simulator

## App Details
- **Package Name:** flow_iq
- **Display Name:** Flow iQ
- **Version:** 2.0.3+1
- **Description:** Professional menstrual health platform with AI-powered insights and clinical integration

## Next Steps
The app is now fully branded as "Flow iQ" across all platforms. When users install the app, they will see "Flow iQ" as the app name on both iOS and Android devices.

## Notes
- The iOS configuration was already using "Flow iQ" correctly
- Main update was the Android manifest label
- All existing documentation (README.md, permissions, etc.) already references "Flow iQ"
- App functionality remains unchanged - this was purely a branding consistency update
