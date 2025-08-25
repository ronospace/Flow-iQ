# Flow iQ Deployment Guide 🚀

This guide provides step-by-step instructions for deploying Flow iQ to all supported platforms.

## Prerequisites

Before deploying, ensure you have:

- ✅ Flutter SDK (>=3.8.1) installed
- ✅ Firebase CLI installed and configured
- ✅ Platform-specific development tools set up
- ✅ All dependencies installed (`flutter pub get`)
- ✅ Firebase project configured (`firebase login`)

## Quick Deployment Commands

### Web (Fastest - 5 minutes)
```bash
flutter build web --release
firebase deploy --only hosting
```

### iOS (TestFlight)
```bash
flutter build ios --release
# Then use Xcode to upload to App Store Connect
```

### Android (Play Store)
```bash
flutter build appbundle --release
# Upload to Google Play Console
```

---

## 🌐 Web Deployment

### Option 1: Firebase Hosting (Recommended)

#### 1. Build for Production
```bash
# Build optimized web version
flutter build web --release --web-renderer canvaskit

# Optional: Build with specific base URL
flutter build web --release --base-href /your-app-path/
```

#### 2. Deploy to Firebase
```bash
# Deploy to Firebase Hosting
firebase deploy --only hosting

# Deploy with specific project
firebase deploy --project flow-iq-app --only hosting
```

#### 3. Custom Domain (Optional)
```bash
# Add custom domain in Firebase Console
# Or via CLI:
firebase hosting:sites:create your-custom-domain
```

#### 4. Verify Deployment
- Visit: https://flow-iq-app.web.app
- Check PWA functionality
- Test offline capabilities
- Verify Firebase authentication

### Option 2: Other Web Hosts

#### Netlify
```bash
# Build
flutter build web --release

# Deploy (drag-and-drop build/web folder to Netlify)
# Or use Netlify CLI:
npm install -g netlify-cli
netlify deploy --prod --dir=build/web
```

#### GitHub Pages
```bash
# Build with correct base href
flutter build web --release --base-href /your-repo-name/

# Copy build/web contents to gh-pages branch
# Or use GitHub Actions for automatic deployment
```

#### Vercel
```bash
# Install Vercel CLI
npm install -g vercel

# Build and deploy
flutter build web --release
vercel --prod build/web
```

---

## 📱 iOS Deployment

### Prerequisites
- macOS with Xcode installed
- Apple Developer Account ($99/year)
- iOS Provisioning Profiles configured

### 1. Build Configuration

#### Update Version
```yaml
# pubspec.yaml
version: 1.0.0+1  # Update version and build number
```

#### Configure Xcode Project
```bash
cd ios
open Runner.xcworkspace
```

In Xcode:
1. Select **Runner** target
2. Update **Bundle Identifier**: `com.flowiq.flow_iq`
3. Set **Team** to your Apple Developer Team
4. Configure **Signing & Capabilities**

### 2. Build for Release
```bash
# Build iOS release
flutter build ios --release

# Or build without code signing for testing
flutter build ios --release --no-codesign
```

### 3. Archive and Upload

#### Option A: Using Xcode
1. Open `ios/Runner.xcworkspace`
2. Select **Generic iOS Device** or connected device
3. **Product → Archive**
4. **Distribute App → App Store Connect**
5. Follow the upload wizard

#### Option B: Using Command Line
```bash
# Archive
xcodebuild -workspace ios/Runner.xcworkspace \
           -scheme Runner \
           -configuration Release \
           -archivePath build/Runner.xcarchive \
           archive

# Upload to App Store Connect
xcodebuild -exportArchive \
           -archivePath build/Runner.xcarchive \
           -exportOptionsPlist ios/ExportOptions.plist \
           -exportPath build/ios_export
```

### 4. App Store Connect Setup
1. Create new app in [App Store Connect](https://appstoreconnect.apple.com)
2. Fill in app metadata:
   - **Name**: Flow iQ
   - **SKU**: flowiq-ios
   - **Bundle ID**: com.flowiq.flow_iq
3. Add screenshots and descriptions
4. Submit for review

### 5. TestFlight Beta Testing
1. Upload build to App Store Connect
2. Add internal testers
3. Create external test group (optional)
4. Send test links to beta users

---

## 🤖 Android Deployment

### Prerequisites
- Android Studio installed
- Google Play Developer Account ($25 one-time)
- App signing key configured

### 1. Generate Signing Key
```bash
# Generate upload key (first time only)
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Create key.properties file
echo "storePassword=your_store_password
keyPassword=your_key_password  
keyAlias=upload
storeFile=/path/to/upload-keystore.jks" > android/key.properties
```

### 2. Configure Gradle
```gradle
// android/app/build.gradle

android {
    defaultConfig {
        applicationId "com.flowiq.flow_iq"
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 3. Build Release
```bash
# Build APK (for direct distribution)
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### 4. Google Play Console Setup
1. Create app in [Google Play Console](https://play.google.com/console)
2. Upload app bundle: `build/app/outputs/bundle/release/app-release.aab`
3. Fill in store listing:
   - **App name**: Flow iQ
   - **Package name**: com.flowiq.flow_iq
   - **Category**: Health & Fitness
4. Add screenshots and descriptions
5. Submit for review

### 5. Internal Testing
```bash
# Upload to internal testing track
# Use Play Console web interface or:
# Upload via fastlane (advanced)
```

---

## 🖥️ macOS Deployment

### Prerequisites
- macOS development environment
- Apple Developer Account
- macOS app signing certificates

### 1. Build Configuration
```bash
# Update macOS deployment target
# macos/Runner.xcodeproj/project.pbxproj
MACOSX_DEPLOYMENT_TARGET = 11.0
```

### 2. Build for Release
```bash
# Build macOS release
flutter build macos --release
```

### 3. Code Signing and Notarization
```bash
# Sign the app
codesign --force --deep --sign "Developer ID Application: Your Name" \
         build/macos/Build/Products/Release/Flow\ iQ.app

# Create installer package
productbuild --component "build/macos/Build/Products/Release/Flow iQ.app" \
            /Applications \
            --sign "Developer ID Installer: Your Name" \
            Flow-iQ-Installer.pkg

# Notarize with Apple
xcrun altool --notarize-app \
             --primary-bundle-id com.flowiq.flow_iq \
             --username "your-apple-id" \
             --password "app-specific-password" \
             --file Flow-iQ-Installer.pkg
```

### 4. Mac App Store (Optional)
1. Configure app in App Store Connect
2. Upload via Xcode or Application Loader
3. Follow iOS App Store process

---

## 🪟 Windows Deployment

### Prerequisites
- Windows development environment
- Visual Studio with C++ tools
- Windows signing certificate (optional)

### 1. Build for Release
```bash
# Build Windows release
flutter build windows --release
```

### 2. Create Installer
```bash
# Using Inno Setup (recommended)
# 1. Install Inno Setup
# 2. Create installer script
# 3. Build installer

# Or using MSIX for Microsoft Store
flutter pub add msix
flutter pub get
flutter build windows
flutter pub run msix:create
```

### 3. Microsoft Store (Optional)
1. Create app in [Partner Center](https://partner.microsoft.com)
2. Upload MSIX package
3. Fill in store listing
4. Submit for certification

---

## 🐧 Linux Deployment (Future)

### Build for Linux
```bash
# Enable Linux desktop support
flutter config --enable-linux-desktop

# Build Linux release
flutter build linux --release
```

### Package for Distribution
```bash
# Create AppImage
# Create .deb package
# Create .rpm package
# Create Flatpak
# Create Snap package
```

---

## 🔧 Advanced Deployment Options

### Continuous Integration/Continuous Deployment (CI/CD)

#### GitHub Actions
```yaml
# .github/workflows/deploy.yml
name: Deploy Flow iQ

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter build web --release
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          projectId: flow-iq-app
```

#### Fastlane (Mobile)
```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

platform :ios do
  lane :release do
    build_app
    upload_to_app_store
  end
end
```

### Environment Management
```bash
# Development
firebase use development
flutter run --debug

# Staging  
firebase use staging
flutter build web --dart-define=ENVIRONMENT=staging

# Production
firebase use production
flutter build web --release --dart-define=ENVIRONMENT=production
```

### Performance Optimization
```bash
# Web optimization
flutter build web --release \
  --web-renderer canvaskit \
  --tree-shake-icons \
  --split-debug-info=debug-symbols \
  --obfuscate

# Mobile optimization
flutter build apk --release \
  --split-per-abi \
  --tree-shake-icons \
  --obfuscate \
  --split-debug-info=debug-symbols
```

---

## 🔍 Testing Deployments

### Pre-deployment Checklist
- [ ] All tests passing (`flutter test`)
- [ ] No analyzer warnings (`flutter analyze`)
- [ ] Firebase configuration verified
- [ ] Version numbers updated
- [ ] Changelog updated
- [ ] Screenshots and metadata ready

### Post-deployment Verification
- [ ] App launches successfully
- [ ] User authentication works
- [ ] Data synchronization functional
- [ ] All core features accessible
- [ ] Performance metrics acceptable
- [ ] Error monitoring active

### Testing Commands
```bash
# Run all tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Performance testing
flutter test --reporter json | jq '.["tests"]'

# Firebase rules testing
firebase emulators:start --only firestore
flutter test test/firebase_test.dart
```

---

## 📊 Monitoring Deployment

### Firebase Analytics
- Monitor active users
- Track feature usage
- Monitor performance metrics
- Track crash-free users

### Error Monitoring
- Firebase Crashlytics (mobile)
- Sentry.io (cross-platform)
- Custom error reporting

### Performance Monitoring
- Firebase Performance Monitoring
- Web Vitals (web)
- App startup time
- Network request monitoring

### Commands for Monitoring
```bash
# View Firebase projects
firebase projects:list

# Check deployment status
firebase hosting:sites:list

# View real-time logs
firebase functions:log --only hosting

# Analytics reports
firebase apps:sdkconfig --platform=web
```

---

## 🆘 Troubleshooting Deployment

### Common Issues

#### Web Deployment
```bash
# Issue: Build fails with memory error
# Solution: Increase memory limit
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true

# Issue: Firebase deployment fails
# Solution: Check project permissions
firebase projects:list
firebase use flow-iq-app
```

#### iOS Deployment
```bash
# Issue: Code signing error
# Solution: Check certificates and profiles
security find-identity -v -p codesigning

# Issue: Archive upload fails
# Solution: Check Xcode version compatibility
xcode-select --print-path
```

#### Android Deployment
```bash
# Issue: Build fails with minSdk error
# Solution: Update android/app/build.gradle
defaultConfig {
    minSdkVersion 21  // Update minimum SDK
}

# Issue: Upload key not found
# Solution: Verify key.properties file path
ls -la android/key.properties
```

### Getting Help
- 📧 Email: support@flowiq.app
- 💬 Discord: [Flow iQ Community](https://discord.gg/flowiq)
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/flow-iq/issues)
- 📖 Wiki: [GitHub Wiki](https://github.com/yourusername/flow-iq/wiki)

---

## 🎯 Deployment Success Checklist

### Pre-Launch
- [ ] All platforms built successfully
- [ ] Firebase services configured and tested
- [ ] Security rules deployed and verified
- [ ] Analytics and monitoring set up
- [ ] Error reporting configured
- [ ] Performance monitoring active

### Launch
- [ ] Web app deployed to Firebase Hosting
- [ ] iOS app uploaded to App Store Connect
- [ ] Android app uploaded to Play Console
- [ ] Desktop apps built and ready for distribution
- [ ] Documentation updated with deployment info

### Post-Launch
- [ ] Monitor error rates and performance
- [ ] Track user adoption and engagement
- [ ] Gather user feedback
- [ ] Plan next iteration based on metrics
- [ ] Update deployment documentation as needed

---

*This deployment guide is regularly updated. For the latest version, check the [GitHub repository](https://github.com/yourusername/flow-iq).*
