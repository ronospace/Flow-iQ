# Android Google Play Submission Guide - Flow iQ v2.0.3

## 🤖 Build Android App Bundle (AAB)

### Quick Build Command
```bash
cd /Users/ronos/Workspace/Projects/Active/Flow-Ai
flutter build appbundle --release
```

## 📦 Release Configuration

### Current Status
- **Version:** 2.0.3
- **Version Code:** 1
- **Package:** com.flowiq.flow_iq
- **Minimum SDK:** 26 (Android 8.0)
- **Target SDK:** 34 (Android 14)

### Output Location
After successful build:
```
build/app/outputs/bundle/release/app-release.aab
```

## ⚠️ IMPORTANT: Signing Configuration

### For Debug Build (Testing Only)
The current configuration uses debug signing. For Google Play submission, you **MUST** configure production signing.

### Production Signing Setup

#### Step 1: Generate Upload Keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

Fill in the prompts:
- Password: [Create a strong password]
- Name: Your name
- Organization: Your organization
- City, State, Country: Your location

#### Step 2: Create `key.properties` File
Create file at: `android/key.properties`

```properties
storePassword=[Your keystore password]
keyPassword=[Your key password]
keyAlias=upload
storeFile=[Path to upload-keystore.jks, e.g., /Users/ronos/upload-keystore.jks]
```

**⚠️ IMPORTANT:** Add `android/key.properties` to `.gitignore` to prevent committing secrets!

#### Step 3: Update `android/app/build.gradle.kts`

Add before `android {` block:
```kotlin
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

Update `signingConfigs` section:
```kotlin
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties['keyAlias']
        keyPassword = keystoreProperties['keyPassword']
        storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword = keystoreProperties['storePassword']
    }
}
```

Update `buildTypes` section:
```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        // ... other config
    }
}
```

## 🏗️ Build Process

### Step 1: Clean Build
```bash
flutter clean
flutter pub get
```

### Step 2: Build AAB
```bash
flutter build appbundle --release
```

### Step 3: Verify Build
```bash
ls -lh build/app/outputs/bundle/release/app-release.aab
```

### Step 4: Verify Signing
```bash
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

Should show: "jar verified."

## 📤 Upload to Google Play Console

### Method 1: Via Web Console
1. Go to https://play.google.com/console
2. Select your app (or create new app)
3. Navigate to **Release → Production**
4. Click **Create new release**
5. Upload `app-release.aab`
6. Fill in release details:
   - **Release name:** 2.0.3
   - **Release notes:** [Your release notes]
7. Review and roll out

### Method 2: Via Command Line (Advanced)
Using `fastlane` or Google Play Developer API.

## 📋 Pre-Submission Checklist

### Required Assets:
- [ ] **App Icon** - 512x512 PNG (high-res icon)
- [ ] **Feature Graphic** - 1024x500 PNG
- [ ] **Screenshots:**
  - Phone: At least 2 (up to 8)
  - 7-inch tablet: At least 2
  - 10-inch tablet: At least 2

### Required Information:
- [ ] **App Title** (max 50 characters)
- [ ] **Short Description** (max 80 characters)
- [ ] **Full Description** (max 4000 characters)
- [ ] **Privacy Policy URL**
- [ ] **App Category** (e.g., Health & Fitness)
- [ ] **Content Rating** questionnaire
- [ ] **Target Audience** declaration

### Compliance:
- [ ] **Data Safety** form completed
- [ ] **App Content** declarations
- [ ] **Privacy Policy** accessible
- [ ] **Families Policy** (if targeting children)

## 🐛 Troubleshooting

### Issue: "Debug keystore" Warning
**Solution:** Follow production signing setup above.

### Issue: Build Fails - Gradle Error
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build appbundle --release
```

### Issue: Missing Dependencies
**Solution:**
```bash
flutter pub get
cd android
./gradlew --refresh-dependencies
```

### Issue: Package Name Already Exists
**Solution:** 
- Change package name in `android/app/build.gradle.kts`
- Update `AndroidManifest.xml`
- Create new app in Play Console

## 🎯 Testing Before Release

### Test on Physical Device
```bash
# Build APK for testing
flutter build apk --release

# Install on connected device
flutter install
```

### Internal Testing Track
1. Upload AAB to Play Console
2. Create **Internal Testing** release first
3. Add test users
4. Test thoroughly before production

## 📱 Version Management

### Update Version for Next Release
In `pubspec.yaml`:
```yaml
version: 2.0.4+2  # version_name+version_code
```

Version code must always increment for each release.

## 📞 Resources
- **Play Console:** https://play.google.com/console
- **Developer Policy:** https://play.google.com/about/developer-content-policy/
- **Release Checklist:** https://developer.android.com/distribute/best-practices/launch/launch-checklist

---

**Generated:** October 29, 2025  
**Package:** com.flowiq.flow_iq  
**Version:** 2.0.3 (Build 1)
