# iOS App Store Submission Guide - Flow iQ v2.0.3

## ✅ Build Status
- **Archive Created:** ✓ `/Users/ronos/Workspace/Projects/Active/Flow-Ai/build/ios/archive/Runner.xcarchive`
- **Size:** 408.2MB
- **Version:** 2.0.3 (Build 1)
- **Bundle ID:** com.flowai.health.flowAi

## 📱 Export via Xcode Organizer

### Step 1: Open Xcode Organizer
```bash
open /Users/ronos/Workspace/Projects/Active/Flow-Ai/build/ios/archive/Runner.xcarchive
```

This will automatically open Xcode Organizer with your archive selected.

### Step 2: Distribute App
1. In Xcode Organizer window, click **"Distribute App"** button
2. Select **"App Store Connect"** → Click **Next**
3. Select **"Upload"** → Click **Next**
4. Choose distribution options:
   - **App Thinning:** All compatible device variants
   - **Include bitcode:** ☑️ Yes (if available)
   - **Upload symbols:** ☑️ Yes
   - **Manage Version and Build Number:** ☑️ Automatically
5. Click **Next**

### Step 3: Sign with Your Team
1. **Automatically manage signing** (Recommended)
   - Xcode will use your development team certificate
   - Team ID: (Will be filled automatically from your Apple Developer account)
   
2. Click **Next**

### Step 4: Review and Upload
1. Review app details:
   - Name: Flow iQ
   - Version: 2.0.3
   - Build: 1
   - Bundle ID: com.flowai.health.flowAi
   
2. Click **Upload**
3. Wait for upload to complete (may take 5-15 minutes depending on connection)

## 🚀 Alternative: Apple Transporter

### Step 1: Export IPA Manually
1. Open Xcode → Window → Organizer
2. Select your archive
3. Click "Distribute App"
4. Choose "App Store Connect" → "Export"
5. Save the .ipa file to a location (e.g., Desktop)

### Step 2: Upload via Transporter
1. Download **Transporter** from Mac App Store if not installed
2. Open Transporter app
3. Drag and drop your exported .ipa file
4. Click "Deliver"
5. Sign in with your Apple ID
6. Wait for validation and upload

## ⚠️ Pre-Submission Checklist

### Required Before App Store Submission:
- [ ] **Replace App Icon** - Currently using placeholder
- [ ] **Replace Launch Screen** - Currently using placeholder
- [ ] **Configure App Store Connect**
  - Create app record
  - Add screenshots (iPhone 6.5", iPad 13")
  - Write app description
  - Add keywords
  - Set privacy policy URL
  - Configure age rating
- [ ] **Set up In-App Purchases** (if applicable)
- [ ] **Configure App Tracking Transparency** (if using analytics)
- [ ] **Verify Bundle ID** matches App Store Connect

### Testing Before Submission:
- [ ] Test demo login: demo@flowiq.health / FlowIQ2024Demo!
- [ ] Test theme switcher (Light/Dark/Auto)
- [ ] Verify Firebase integration
- [ ] Test all main screens (Home, Track, Insights, Health, Settings)
- [ ] Check no crash logs in Xcode Organizer

## 📝 Version Info
- **App Name:** Flow iQ
- **Version:** 2.0.3
- **Build:** 1
- **Bundle ID:** com.flowai.health.flowAi
- **Minimum iOS:** 13.0
- **Deployment Target:** iOS 13.0+

## 🔧 Troubleshooting

### Issue: "No Accounts" Error
**Solution:** Sign in to Xcode with your Apple Developer account:
1. Xcode → Settings → Accounts
2. Click "+" → Add Apple ID
3. Sign in with your Apple Developer credentials

### Issue: "No Signing Certificate" Error
**Solution:** 
1. Open Xcode project
2. Select Runner target
3. Signing & Capabilities tab
4. Enable "Automatically manage signing"
5. Select your team
6. Rebuild archive

### Issue: Upload Fails
**Solution:**
- Check internet connection
- Verify Apple Developer Program membership is active
- Ensure Bundle ID is registered in App Store Connect
- Try using Transporter as alternative

## 📞 Support
- **Apple Developer:** https://developer.apple.com/support/
- **App Store Connect:** https://appstoreconnect.apple.com/
- **Transporter:** https://apps.apple.com/app/transporter/id1450874784

---

**Generated:** October 29, 2025  
**Archive Location:** `build/ios/archive/Runner.xcarchive`
